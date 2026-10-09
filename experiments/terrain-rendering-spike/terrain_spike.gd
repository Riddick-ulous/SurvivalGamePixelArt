extends Node3D
## Isolated, deterministic Godot 4 spike. No Simulation.Core or tileset dependency.
const GRID := 64
const EXTENT := 16.0
const STEP := EXTENT / GRID
const SEED := 1909
const MODES := ["R0 debug", "R1 continuous material", "R2 pixel clusters"]
const CASES := ["A natural", "B excavation", "C mound"]
var mode_id := 0
var case_id := 0
var terrain_mesh: MeshInstance3D
var terrain_material: ShaderMaterial
var camera: Camera3D
var info: Label
var decor_root: Node3D
var pitch := 45.0

func _ready() -> void:
    RenderingServer.set_default_clear_color(Color(0.13, 0.17, 0.18))
    _build_camera()
    _build_terrain()
    _build_decor()
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
    for item in decor_root.get_children():
        var x: float = item.get_meta("ground_x")
        var z: float = item.get_meta("ground_z")
        item.position.y = _height(x,z)+0.17
    info.text = "%s | %s | pitch %.0f°\n1/2/3: R0/R1/R2   A/B/C: natural/dig/mound\nQ/W/E: pitch 35/45/55   S: save screenshot\nProcedural materials, not reference-derived assets" % [MODES[mode_id],CASES[case_id],pitch]

func _unhandled_key_input(event: InputEvent) -> void:
    if not (event is InputEventKey) or not event.pressed or event.echo:
        return
    match event.keycode:
        KEY_1: mode_id = 0
        KEY_2: mode_id = 1
        KEY_3: mode_id = 2
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
    var name := "terrain_%s_%s_%02d.png" % [MODES[mode_id].substr(0,2),CASES[case_id].substr(0,1),int(pitch)]
    var path := "user://" + name
    var err := img.save_png(path)
    print("Screenshot: ",ProjectSettings.globalize_path(path)," error=",err)
