extends Node3D

const FIGHTER = preload("res://scenes/Fighter.tscn")
const BOT = preload("res://scenes/Bot.tscn")

var score := 0
var time_left := 180.0
var hud_label: Label
var score_label: Label

func _ready() -> void:
    _build_hud()
    _spawn_fighter(Vector3(0, 0.8, 4), true)
    for i in range(5):
        _spawn_fighter(Vector3(randf_range(-10, 10), 0.8, randf_range(-9, -3)), false)
    _make_obstacles()

func _process(delta: float) -> void:
    time_left = maxf(0.0, time_left - delta)
    if is_instance_valid(hud_label):
        hud_label.text = "BRAWL LEGENDS   •   %02d:%02d" % [int(time_left) / 60, int(time_left) % 60]
    if is_instance_valid(score_label):
        score_label.text = "СЧЁТ  %d     |     WASD — движение • мышь/ПРОБЕЛ — атака" % score

func add_score(points: int) -> void:
    score += points

func _spawn_fighter(pos: Vector3, is_player: bool) -> void:
    var actor = FIGHTER.instantiate() if is_player else BOT.instantiate()
    actor.position = pos
    actor.set("is_player", is_player)
    actor.set("arena", self)
    $Actors.add_child(actor)

func _make_obstacles() -> void:
    for i in range(18):
        var block := StaticBody3D.new()
        block.position = Vector3(randf_range(-12, 12), 0.65, randf_range(-10, 10))
        var mesh := MeshInstance3D.new()
        var box := BoxMesh.new()
        box.size = Vector3(randf_range(1.0, 2.2), 1.3, randf_range(1.0, 2.2))
        mesh.mesh = box
        var mat := StandardMaterial3D.new()
        mat.albedo_color = [Color("#e6a14a"), Color("#55b96b"), Color("#b66ce0")].pick_random()
        mat.roughness = 0.9
        mesh.material_override = mat
        block.add_child(mesh)
        var collision := CollisionShape3D.new()
        var shape := BoxShape3D.new()
        shape.size = box.size
        collision.shape = shape
        block.add_child(collision)
        $Actors.add_child(block)

func _build_hud() -> void:
    var panel := PanelContainer.new()
    panel.position = Vector2(18, 14)
    panel.custom_minimum_size = Vector2(700, 78)
    $HUD.add_child(panel)
    var col := VBoxContainer.new()
    panel.add_child(col)
    hud_label = Label.new()
    hud_label.add_theme_font_size_override("font_size", 24)
    hud_label.text = "BRAWL LEGENDS"
    col.add_child(hud_label)
    score_label = Label.new()
    score_label.add_theme_font_size_override("font_size", 16)
    score_label.text = "СЧЁТ  0"
    col.add_child(score_label)
