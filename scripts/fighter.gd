extends CharacterBody3D

@export var speed := 7.0
@export var max_health := 100
var health := 100
var is_player := true
var arena: Node
var attack_cooldown := 0.0
var tint := Color("#a64dff")

func _ready() -> void:
    health = max_health
    var body = get_node_or_null("Body")
    if body:
        var mat := StandardMaterial3D.new()
        mat.albedo_color = tint if is_player else Color("#3b8dff")
        mat.roughness = 0.55
        body.material_override = mat
    if is_player:
        tint = Color("#b14dff")
        Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

func _physics_process(delta: float) -> void:
    attack_cooldown = maxf(0.0, attack_cooldown - delta)
    if is_player:
        _player_move()
        if Input.is_action_just_pressed("attack") or Input.is_key_pressed(KEY_SPACE):
            _attack()
    else:
        _bot_move(delta)
    move_and_slide()
    global_position.x = clampf(global_position.x, -14, 14)
    global_position.z = clampf(global_position.z, -14, 14)

func _player_move() -> void:
    var input_vec := Vector2(
        Input.get_action_strength("move_right") - Input.get_action_strength("move_left"),
        Input.get_action_strength("move_back") - Input.get_action_strength("move_forward")
    )
    var dir := Vector3(input_vec.x, 0, input_vec.y).normalized()
    velocity.x = dir.x * speed
    velocity.z = dir.z * speed
    if dir.length() > 0.1:
        rotation.y = atan2(-dir.x, -dir.z)

func _bot_move(delta: float) -> void:
    var target := Vector3.ZERO
    var player = get_tree().get_first_node_in_group("player")
    if player:
        target = player.global_position
    var dir := target - global_position
    dir.y = 0
    if dir.length() > 2.2:
        dir = dir.normalized()
        velocity.x = dir.x * speed * 0.48
        velocity.z = dir.z * speed * 0.48
    else:
        velocity.x = 0
        velocity.z = 0
        if attack_cooldown <= 0:
            _attack()
    if dir.length() > 0.1:
        rotation.y = atan2(-dir.x, -dir.z)

func _attack() -> void:
    if attack_cooldown > 0:
        return
    attack_cooldown = 0.65
    var candidates = get_tree().get_nodes_in_group("fighter")
    for other in candidates:
        if other == self or not is_instance_valid(other):
            continue
        if global_position.distance_to(other.global_position) < 2.5:
            if other.is_player != is_player:
                other.take_damage(25)
                if is_player:
                    break

func take_damage(amount: int) -> void:
    health -= amount
    if health <= 0:
        if is_player:
            health = max_health
            global_position = Vector3(0, 0.8, 4)
        else:
            if is_instance_valid(arena):
                arena.add_score(1)
            queue_free()

func _enter_tree() -> void:
    add_to_group("fighter")
    if is_player:
        add_to_group("player")
