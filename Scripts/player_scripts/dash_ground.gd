extends PlayerState

@onready var animation_player: AnimationPlayer = $"../../../AnimationPlayer"
@onready var collision_shape_3d: CollisionShape3D = $"../../../AttackHitbox/CollisionShape3D"
@onready var attack_hitbox: Area3D = $"../../../AttackHitbox"
@onready var attack_mesh: MeshInstance3D = $"../../../AttackHitbox/AttackMesh"
@onready var move: PlayerState = $"../../Move"
@onready var jump: PlayerState = $"../../Jump"

# numer of frames player can adjust direction of dash
const CONTROL_TIME : float = 0.25
const CANCEL_TIME : float = 0.25
const TOTAL_TIME : float = 0.75
const TURN_STRENGTH_START : int = 365
const TURN_STRENGTH_END : int = 12
const WEAK_BOOST : float = 0.5
const WEAK_DEACCEL: int = 4
const MEDIUM_BOOST : float = 0.65
const MEDIUM_DEACCEL : int = 6
const STRONG_BOOST : float = 0.85
const STRONG_DEACCEL : int = 8

var time : float
var speed_curve_boost : float
var speed_curve_deaccel : int
var prev_speed_curve_in : float

func enter() -> void:
	animation_player.animation_finished.connect(_on_animation_player_animation_finished)
	attack_hitbox.body_entered.connect(_on_attack_hitbox_body_entered)
	time = 0
	prev_speed_curve_in = speed_curve_in
	
	if speed_curve_in < NORMAL_SPEED_CURVE_IN_TRESHOLD:
		speed_curve_boost = WEAK_BOOST
		speed_curve_deaccel = WEAK_DEACCEL
	elif speed_curve_in < STRONG_SPEED_CURVE_IN_TRESHOLD:
		speed_curve_boost = MEDIUM_BOOST
		speed_curve_deaccel = MEDIUM_DEACCEL
	else:
		speed_curve_boost = STRONG_BOOST
		speed_curve_deaccel = STRONG_DEACCEL

func process_physics(_delta: float) -> State:
	var state = null
	var input_dir = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down").normalized()
	input_dir = Vector3(input_dir.x, 0.0, input_dir.y)
	if time <= CONTROL_TIME:
		parent.velocity = parse_movement_input(input_dir, _delta,
				clamp(TURN_STRENGTH_START * _delta *(1/parent.velocity.length()), 0, 1), true)
		speed_curve_in = lerp(speed_curve_in, prev_speed_curve_in + speed_curve_boost, clamp(12 * _delta, 0, 1))
	elif time <= TOTAL_TIME:
		speed_curve_in = lerp(speed_curve_in, prev_speed_curve_in, clamp(speed_curve_deaccel * _delta, 0, 1))
		parent.velocity = parse_movement_input(input_dir, _delta,
				clamp(TURN_STRENGTH_END * _delta *(1/parent.velocity.length()), 0, 1), true)
	else:
		state = move
	parent.move_and_slide()
	time += _delta
	return state

func process_input(_event: InputEvent) -> State:
	var attacks : Array[PlayerState.Attacks] = parent.attacks
	var state : PlayerState = null
	
	if time > CANCEL_TIME:
		if Input.is_action_just_pressed("attack0") && attacks.size() > 0 && !(attacks[0] == PlayerState.Attacks.DASH) :
			state = get_node_or_null("../../Attack0")
		if Input.is_action_just_pressed("attack1") && attacks.size() > 1 && !(attacks[1] == PlayerState.Attacks.DASH):
			state = get_node_or_null("../../Attack1")
		if Input.is_action_just_pressed("attack2") && attacks.size() > 2 && !(attacks[2] == PlayerState.Attacks.DASH):
			state = get_node_or_null("../../Attack2")
		if Input.is_action_just_pressed("jump"):
			state = jump
	return state

func exit() -> void:
	attack_hitbox.body_entered.disconnect(_on_attack_hitbox_body_entered)
	animation_player.animation_finished.disconnect(_on_animation_player_animation_finished)


func _on_animation_player_animation_finished(_anim_name: StringName) -> void:
	pass


func _on_attack_hitbox_body_entered(_body: Node3D) -> void:
	pass
