extends Node3D
## Isolated, deterministic Godot 4 spike. No Simulation.Core or tileset dependency.
const GRID := 64
const EXTENT := 16.0
const STEP := EXTENT / GRID
const SEED := 1909
const MODES := ["R0 debug", "R1 continuous material", "R2 pixel clusters", "R3 structured assets", "R4 image materials", "R5 stochastic transitions"]
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

func _ready() -> void:
    RenderingServer.set_default_clear_color(Color(0.13, 0.17, 0.18))
    _build_camera()
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

func _height(x: float,z: float) -> float:
    var h: float = 0.12*sin(x*0.7+0.2)*cos(z*0.6) + 0.07*sin(x*1.8+z*0.9)
    var d: float = Vector2(x-8.2,z-8.0).length()
    if case_id == 1:
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
    for z in range(GRID+1):
        for x in range(GRID+1):
            var px := float(x)*STEP
            var pz := float(z)*STEP
            verts.append(Vector3(px,_height(px,pz),pz))
            colors.append(Color(_grass(px,pz),0,0,1))
    for z in range(GRID):
        for x in range(GRID):
            var a := z*(GRID+1)+x
            var b := a+1
            var c := a+(GRID+1)
            var d := c+1
            indices.append_array(PackedInt32Array([a,c,b,b,c,d]))
    var arrays := []
    arrays.resize(Mesh.ARRAY_MAX)
    arrays[Mesh.ARRAY_VERTEX] = verts
    arrays[Mesh.ARRAY_COLOR] = colors
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
    _rebuild_mesh()
    terrain_material.set_shader_parameter("render_mode_id",mode_id)
    terrain_material.set_shader_parameter("world_scale",32.0)
    terrain_material.set_shader_parameter("seed",float(SEED))
    terrain_material.set_shader_parameter("r3_atlas",r3_atlas)
    if mode_id >= 4 and not r4_ready:
        mode_id = 3
        push_warning("R4 PNGs missing. Copy grass_a_256.png, grass_b_256.png, soil_256.png to res://materials/")
    decor_root.visible = mode_id == 3
    for item in decor_root.get_children():
        var x: float = item.get_meta("ground_x")
        var z: float = item.get_meta("ground_z")
        item.position.y = _height(x,z)+0.17
    var zoom_label: String = "close (~4m)" if close_camera else "wide (16m)"
    info.text = "%s | %s | pitch %.0f° | %s\n1-6: R0-R5   A/B/C: natural/dig/mound\nQ/W/E: pitch 35/45/55   Z: toggle zoom   S: screenshot\nR4/R5 use real image materials" % [MODES[mode_id],CASES[case_id],pitch,zoom_label]

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
