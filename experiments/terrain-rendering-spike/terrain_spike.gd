extends Node3D
## Isolated, deterministic Godot 4 spike. No Simulation.Core or tileset dependency.
const GRID := 64
const R7_GRID := 128
const EXTENT := 16.0
const STEP := EXTENT / GRID
const SEED := 1909
const MODES := ["R0 debug", "R1 continuous material", "R2 pixel clusters", "R3 structured assets", "R4 image materials", "R5 stochastic transitions", "R6 excavated terrain", "R7 lit square pit", "R7.1 light debug", "R7.2 grass edge geometry"]
const CASES := ["A natural", "B excavation", "C mound"]
var mode_id := 0
var case_id := 0
var terrain_mesh: MeshInstance3D
var terrain_material: ShaderMaterial
var camera: Camera3D
var info: Label
var decor_root: Node3D
var pitch := 45.0
var r3_atlas: Texture2D
var r3_overlay: Texture2D
var r4_ready: bool = false
var close_camera: bool = false
var r6_debug: bool = false
var lighting_debug_mode: int = 0
var shadow_test: bool = false
var sun_direction_id: int = 0
@export_range(0.0, 3.0, 0.05) var sun_energy: float = 0.80
@export_range(0.0, 2.0, 0.05) var ambient_energy: float = 0.30
var r71_environment: Environment
var r71_sun: DirectionalLight3D
var reference_mesh: MeshInstance3D
var show_light_reference: bool = false

func _ready() -> void:
    RenderingServer.set_default_clear_color(Color(0.13, 0.17, 0.18))
    _build_camera()
    _build_lighting()
    _build_reference_mesh()
    _build_terrain()
    _build_decor()
    _build_r3_assets()
    _load_r4_materials()
    _build_ui()
    _update_scene()

func _build_camera() -> void:
    camera = Camera3D.new()
    add_child(camera)
    camera.projection = Camera3D.PROJECTION_ORTHOGONAL
    camera.size = 23.0
    camera.current = true
    _position_camera()

func _position_camera() -> void:
    var angle := deg_to_rad(pitch)
    camera.size = 5.7 if close_camera else 23.0
    camera.position = Vector3(8.0, 18.0*sin(angle), 8.0+18.0*cos(angle))
    camera.look_at(Vector3(8.0,0.0,8.0),Vector3.UP)

func _build_lighting() -> void:
    var sun := DirectionalLight3D.new()
    sun.name = "R7_Sun"
    sun.rotation_degrees = Vector3(-60.0,-45.0,0.0)
    sun.light_energy = sun_energy
    sun.shadow_enabled = false
    add_child(sun)
    var environment := WorldEnvironment.new()
    var settings := Environment.new()
    settings.background_mode = Environment.BG_COLOR
    settings.background_color = Color(0.13,0.17,0.18)
    settings.ambient_light_source = Environment.AMBIENT_SOURCE_COLOR
    settings.ambient_light_color = Color(0.75,0.80,0.83)
    settings.ambient_light_energy = ambient_energy
    r71_environment = settings
    environment.environment = settings
    add_child(environment)
    sun.visible = false
    r71_sun = sun

func _build_reference_mesh() -> void:
    # Neutral reference: if this cube reacts to light, the scene light works.
    reference_mesh = MeshInstance3D.new()
    reference_mesh.name = "R71_White_Light_Reference"
    var cube := BoxMesh.new()
    cube.size = Vector3(0.8,0.8,0.8)
    reference_mesh.mesh = cube
    var white := StandardMaterial3D.new()
    white.albedo_color = Color.WHITE
    white.roughness = 1.0
    white.metallic = 0.0
    reference_mesh.material_override = white
    reference_mesh.position = Vector3(7.0,0.6,7.0)
    reference_mesh.visible = false
    add_child(reference_mesh)

func _r7_depth(x: float,z: float) -> float:
    var dx: float = x-8.2
    var dz: float = z-8.0
    var irregular: float = 0.08*sin(dx*7.1+dz*2.3)+0.06*sin(dz*8.3-dx*3.1)
    var p := Vector2(absf(dx),absf(dz))-Vector2(1.45+irregular,1.45-irregular)
    var d: float = Vector2(maxf(p.x,0.0),maxf(p.y,0.0)).length()+minf(maxf(p.x,p.y),0.0)-0.16
    return 1.1*(1.0-smoothstep(-0.35,0.17,d))

func _path_edge_distance(x: float, z: float) -> float:
    # World-coordinate signed distance, matching the material shader.
    var center: float = 6.1 + 0.85*sin(x*0.42)
    center += 0.40*(sin(x*0.55+1.7)*sin(x*0.31+0.6))
    var half_width: float = 0.62 + 0.12*sin(x*0.75+2.1)
    var jitter: float = 0.09*sin(x*2.2+z*1.7) + 0.035*sin(x*6.0-z*3.0)
    return absf(z-center)-half_width+jitter

func _height(x: float,z: float) -> float:
    var h: float = 0.12*sin(x*0.7+0.2)*cos(z*0.6) + 0.07*sin(x*1.8+z*0.9)
    var d: float = Vector2(x-8.2,z-8.0).length()
    if mode_id == 9:
        # A shallow, physically raised grass sod at the compacted path edge.
        # World-space, independent of terrain tessellation and texture scale.
        var edge: float = _path_edge_distance(x,z)
        var turf_step: float = smoothstep(-0.055,0.11,edge)
        var broad_lip: float = 1.0-smoothstep(0.11,0.32,edge)
        h += 0.065*turf_step*broad_lip
        # Path is slightly worn down; no change to the excavation logic.
        h -= 0.035*(1.0-smoothstep(-0.22,0.06,edge))
    if case_id == 1:
        if mode_id >= 7:
            h -= _r7_depth(x,z)
        elif mode_id == 6:
            # Flatter excavated floor with steeper but resolvable banks.
            h -= 1.05*(1.0-smoothstep(1.25,2.20,d))
        else:
            h -= 0.72*(1.0-smoothstep(1.0,2.25,d))
    elif case_id == 2:
        h += 1.10*(1.0-smoothstep(0.5,3.2,d))
    return h

func _grass(x: float,z: float) -> float:
    var path_dist: float = absf(z-6.1-0.85*sin(x*0.42))
    var noise: float = 0.12*sin(x*2.1+z*0.8)+0.10*sin(z*3.0-x*1.2)
    return clamp((path_dist-0.62+noise)*1.9+0.50,0.0,1.0)

func _build_terrain() -> void:
    terrain_mesh = MeshInstance3D.new()
    terrain_mesh.name = "Heightfield"
    add_child(terrain_mesh)
    terrain_material = ShaderMaterial.new()
    terrain_material.shader = load("res://terrain_material.gdshader")
    terrain_mesh.material_override = terrain_material

func _rebuild_mesh() -> void:
    var verts := PackedVector3Array()
    var colors := PackedColorArray()
    var indices := PackedInt32Array()
    var normals := PackedVector3Array()
    var grid: int = R7_GRID if mode_id >= 7 else GRID
    var step_size: float = EXTENT/float(grid)
    for z in range(grid+1):
        for x in range(grid+1):
            var px := float(x)*step_size
            var pz := float(z)*step_size
            verts.append(Vector3(px,_height(px,pz),pz))
            var cut_depth: float = 0.0
            if mode_id >= 7 and case_id == 1:
                cut_depth = _r7_depth(px,pz)
            elif mode_id == 6 and case_id == 1:
                cut_depth = 1.05*(1.0-smoothstep(1.25,2.20,Vector2(px-8.2,pz-8.0).length()))
            colors.append(Color(_grass(px,pz),cut_depth,0,1))
            var sx: float = _height(px+step_size,pz)-_height(px-step_size,pz)
            var sz: float = _height(px,pz+step_size)-_height(px,pz-step_size)
            normals.append(Vector3(-sx,2.0*step_size,-sz).normalized())
    for z in range(grid):
        for x in range(grid):
            var a := z*(grid+1)+x
            var b := a+1
            var c := a+(grid+1)
            var d := c+1
            indices.append_array(PackedInt32Array([a,b,c,b,d,c]))
    assert(verts.size() == (grid+1)*(grid+1))
    assert(normals.size() == verts.size())
    assert(indices.size() == grid*grid*6)
    var arrays := []
    arrays.resize(Mesh.ARRAY_MAX)
    arrays[Mesh.ARRAY_VERTEX] = verts
    arrays[Mesh.ARRAY_COLOR] = colors
    arrays[Mesh.ARRAY_NORMAL] = normals
    arrays[Mesh.ARRAY_INDEX] = indices
    var mesh := ArrayMesh.new()
    mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES,arrays)
    terrain_mesh.mesh = mesh

func _build_decor() -> void:
    decor_root = Node3D.new()
    decor_root.name = "ProceduralDecor"
    add_child(decor_root)
    var rng := RandomNumberGenerator.new()
    rng.seed = SEED
    for i in range(12):
        var x := rng.randf_range(0.8,15.2)
        var z := rng.randf_range(0.8,15.2)
        if _grass(x,z) < 0.6:
            continue
        var item := MeshInstance3D.new()
        var m := CylinderMesh.new()
        m.top_radius = 0.025
        m.bottom_radius = 0.11
        m.height = rng.randf_range(0.2,0.42)
        item.mesh = m
        var mat := StandardMaterial3D.new()
        mat.albedo_color = Color(0.20+rng.randf_range(0,0.15),0.34+rng.randf_range(0,0.16),0.13)
        mat.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
        item.material_override = mat
        item.position = Vector3(x,0,z)
        item.set_meta("ground_x",x)
        item.set_meta("ground_z",z)
        decor_root.add_child(item)

func _build_ui() -> void:
    var ui := CanvasLayer.new()
    add_child(ui)
    info = Label.new()
    info.position = Vector2(16,12)
    info.add_theme_color_override("font_color",Color.WHITE)
    info.add_theme_color_override("font_shadow_color",Color.BLACK)
    info.add_theme_constant_override("shadow_offset_x",1)
    info.add_theme_constant_override("shadow_offset_y",1)
    ui.add_child(info)

func _update_scene() -> void:
    if mode_id >= 4 and not r4_ready:
        push_warning("Material textures missing for %s; restore res://materials PNG files." % MODES[mode_id])
    _rebuild_mesh()
    terrain_material.set_shader_parameter("render_mode_id",mode_id)
    r71_sun.visible = mode_id >= 7
    r71_sun.light_energy = sun_energy
    r71_environment.ambient_light_energy = ambient_energy
    r71_sun.shadow_enabled = shadow_test if mode_id >= 8 else true
    r71_sun.rotation_degrees = Vector3(-60.0,-45.0,0.0) if sun_direction_id == 0 else Vector3(-48.0,125.0,0.0)
    reference_mesh.visible = mode_id >= 8 and show_light_reference
    terrain_material.set_shader_parameter("r71_debug_mode",lighting_debug_mode if mode_id >= 8 else 0)
    terrain_material.set_shader_parameter("world_scale",32.0)
    terrain_material.set_shader_parameter("seed",float(SEED))
    terrain_material.set_shader_parameter("r3_atlas",r3_atlas)
    decor_root.visible = mode_id == 3
    for item in decor_root.get_children():
        var x: float = item.get_meta("ground_x")
        var z: float = item.get_meta("ground_z")
        item.position.y = _height(x,z)+0.17
    var zoom_label: String = "close (~4m)" if close_camera else "wide (16m)"
    var texture_status: String = "textures OK" if r4_ready else "MISSING PNG TEXTURES (see Output)"
    info.text = "%s | %s | pitch %.0f° | %s | %s\n1-0: R0-R7.2   A/B/C: natural/dig/mound\nQ/W/E: pitch 35/45/55   Z: zoom   S: screenshot\nR7+: L debug H shadows J sun K reference T/Y sun -/+ G/U ambient -/+\nSun %.2f  Ambient %.2f   R4-R7 use image materials" % [MODES[mode_id],CASES[case_id],pitch,zoom_label,texture_status,sun_energy,ambient_energy]

func _unhandled_key_input(event: InputEvent) -> void:
    if not (event is InputEventKey) or not event.pressed or event.echo:
        return
    match event.keycode:
        KEY_1: mode_id = 0
        KEY_2: mode_id = 1
        KEY_3: mode_id = 2
        KEY_4: mode_id = 3
        KEY_5: mode_id = 4
        KEY_6: mode_id = 5
        KEY_7: mode_id = 6
        KEY_8: mode_id = 7
        KEY_9: mode_id = 8
        KEY_0: mode_id = 9
        KEY_L:
            lighting_debug_mode = (lighting_debug_mode+1)%4
        KEY_H: shadow_test = not shadow_test
        KEY_J: sun_direction_id = (sun_direction_id+1)%2
        KEY_K: show_light_reference = not show_light_reference
        KEY_T: sun_energy = maxf(0.0,sun_energy-0.15)
        KEY_Y: sun_energy = minf(3.0,sun_energy+0.15)
        KEY_G: ambient_energy = maxf(0.0,ambient_energy-0.10)
        KEY_U: ambient_energy = minf(2.0,ambient_energy+0.10)
        KEY_Z: close_camera = not close_camera
        KEY_A: case_id = 0
        KEY_B: case_id = 1
        KEY_C: case_id = 2
        KEY_Q: pitch = 35.0
        KEY_W: pitch = 45.0
        KEY_E: pitch = 55.0
        KEY_S:
            _capture()
            return
        _: return
    _position_camera()
    _update_scene()

func _capture() -> void:
    # Capture after one completed frame; user:// is writable on all platforms.
    await RenderingServer.frame_post_draw
    var img := get_viewport().get_texture().get_image()
    var zoom_label: String = "close" if close_camera else "wide"
    var name := "terrain_%s_%s_%02d_%s.png" % [MODES[mode_id].substr(0,2),CASES[case_id].substr(0,1),int(pitch),zoom_label]
    var path := "user://" + name
    var err := img.save_png(path)
    print("Screenshot: ",ProjectSettings.globalize_path(path)," error=",err)

# R3 assets: deterministic, genuinely transparent pixel clusters. Generated in
# code, not claimed to be AI-extracted artwork. Textures wrap by construction.
func _build_r3_assets() -> void:
    var atlas := Image.create(256,128,false,Image.FORMAT_RGBA8)
    var rng := RandomNumberGenerator.new()
    rng.seed = 20261009
    for y in range(128):
        for x in range(256):
            var grass_side := x < 128
            var n := rng.randf()
            var base := Color(0.20,0.31,0.13) if grass_side else Color(0.34,0.23,0.15)
            var t := floorf(n*5.0)/5.0-0.4
            var color := base+Color(t*0.18,t*0.15,t*0.08,0.0)
            atlas.set_pixel(x,y,color)
    # Wrap-aware painted clusters: no discontinuity at texture edges.
    for grass_side in [true,false]:
        var ox := 0 if grass_side else 128
        for i in range(850):
            var px := rng.randi_range(0,127)
            var py := rng.randi_range(0,127)
            var length := rng.randi_range(1,5)
            var color := Color(0.39,0.48,0.20) if grass_side else Color(0.48,0.33,0.20)
            if rng.randf() < 0.32:
                color = Color(0.12,0.23,0.10) if grass_side else Color(0.20,0.13,0.09)
            for dy in range(length):
                for dx in range(rng.randi_range(1,3)):
                    atlas.set_pixel(ox+posmod(px+dx,128),posmod(py+dy,128),color)
    r3_atlas = ImageTexture.create_from_image(atlas)
    # Alpha overlay, pixel-sized plant sprite; no black background.
    var plant := Image.create(32,32,false,Image.FORMAT_RGBA8)
    plant.fill(Color(0,0,0,0))
    for i in range(11):
        var sx := rng.randi_range(5,26)
        var sy := rng.randi_range(8,25)
        var color := Color(0.29,0.49,0.17,1.0) if i%3 != 0 else Color(0.49,0.60,0.24,1.0)
        for d in range(5):
            var yy := sy-d
            var xx := sx+int(round(sin(float(d+i)*0.9)*2.0))
            if yy >= 0 and yy < 32:
                plant.set_pixel(xx,yy,color)
    r3_overlay = ImageTexture.create_from_image(plant)
    for child in decor_root.get_children():
        child.queue_free()
    for i in range(42):
        var x := rng.randf_range(0.3,15.7)
        var z := rng.randf_range(0.3,15.7)
        if _grass(x,z) < 0.55:
            continue
        var sprite := Sprite3D.new()
        sprite.texture = r3_overlay
        sprite.pixel_size = 0.012
        sprite.billboard = BaseMaterial3D.BILLBOARD_ENABLED
        sprite.texture_filter = BaseMaterial3D.TEXTURE_FILTER_NEAREST
        sprite.no_depth_test = false
        sprite.position = Vector3(x,_height(x,z)+0.17,z)
        sprite.set_meta("ground_x",x)
        sprite.set_meta("ground_z",z)
        decor_root.add_child(sprite)

func _load_r4_materials() -> void:
    var files := ["res://materials/grass_a_256.png", "res://materials/grass_b_256.png", "res://materials/soil_256.png"]
    for path in files:
        if not ResourceLoader.exists(path):
            push_warning("R4 missing texture: " + path)
            return
    var grass_a: Texture2D = load(files[0]) as Texture2D
    var grass_b: Texture2D = load(files[1]) as Texture2D
    var soil: Texture2D = load(files[2]) as Texture2D
    if grass_a == null or grass_b == null or soil == null:
        push_error("R4 could not load material textures")
        return
    terrain_material.set_shader_parameter("grass_a_tex",grass_a)
    terrain_material.set_shader_parameter("grass_b_tex",grass_b)
    terrain_material.set_shader_parameter("soil_tex",soil)
    r4_ready = true
