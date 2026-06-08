extends PlayerState

@onready var animation_player: AnimationPlayer = $"../../../AnimationPlayer"
@onready var collision_shape_3d: CollisionShape3D = $"../../../AttackHitbox/CollisionShape3D"
@onready var attack_hitbox: Area3D = $"../../../AttackHitbox"
@onready var attack_mesh: MeshInstance3D = $"../../../AttackHitbox/AttackMesh"
@onready var move: PlayerState = $"../../Move"
@onready var idle: PlayerState = $"../../Idle"

const DMG: int = 3
const TURN_STRENGTH: int = 12
const WEAK_RADIUS : float = 2
const MEDIUM_RADIUS : float = 3
const STRONG_RADIUS : float = 5

var y_velocity : float
var stored_speed : Vector3 = Vector3.ZERO
var end_triggered : bool
var state : PlayerState = null

func enter() -> void:
	state = null
	y_velocity = 16
	end_triggered = false
	animation_player.animation_finished.connect(_on_animation_player_animation_finished)
	attack_hitbox.body_entered.connect(_on_attack_hitbox_body_entered)
	attack_mesh.visible = true
	collision_shape_3d.shape = CylinderShape3D.new()
	collision_shape_3d.shape.height = 1.4
	collision_shape_3d.shape.radius = 0.7
	attack_mesh.mesh.height = 1.4
	attack_mesh.mesh.top_radius = 0.7
	attack_mesh.mesh.bottom_radius = 0.7
	attack_mesh.position.y = -0.5
	collision_shape_3d.position.y = -0.5

func process_physics(_delta: float) -> State:
	var horiz_vel = Vector3(parent.velocity.x, 0.0, parent.velocity.z)
	var input_dir = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down").normalized()
	input_dir = Vector3(input_dir.x, 0.0, input_dir.y)
	if !parent.is_on_floor():
		parent.velocity = parse_movement_input(input_dir, _delta, 
				clamp(TURN_STRENGTH * _delta * (1/parent.velocity.length()), 0, 1), true)
		speed_curve_in = speed_curve_in - (speed_curve_in * _delta)
		y_velocity = y_velocity - (_delta * parent.get_gravity().length() * 8)
		parent.velocity.y = y_velocity
	elif !end_triggered:
		end_triggered = true
		animation_player.play("uppercut_air_end")
		stored_speed = horiz_vel
		parent.velocity = Vector3.ZERO
		_set_pound_hitbox_radius()
	else:
		parent.velocity = lerp(parent.velocity, stored_speed, 0.2)
		
	parent.move_and_slide()
	return state

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	print("uppercut air")
	if anim_name == "uppercut_air_end":
		print("done!")
		parent.velocity = stored_speed
		if stored_speed.length() < 0.001:
			state = idle
		else:
			state = move

func _on_attack_hitbox_body_entered(body: Node3D) -> void:
	if body is Enemy:
		var enemy : Enemy = body
		enemy.call("damaged", DMG, parent.position)

func _set_pound_hitbox_radius() -> void:
	if speed_curve_in < NORMAL_SPEED_CURVE_IN_TRESHOLD:
		collision_shape_3d.shape.radius = WEAK_RADIUS
		attack_mesh.mesh.top_radius = WEAK_RADIUS
		attack_mesh.mesh.bottom_radius = WEAK_RADIUS
	elif speed_curve_in < STRONG_SPEED_CURVE_IN_TRESHOLD:
		collision_shape_3d.shape.radius = MEDIUM_RADIUS
		attack_mesh.mesh.top_radius = MEDIUM_RADIUS
		attack_mesh.mesh.bottom_radius = MEDIUM_RADIUS
	else:
		collision_shape_3d.shape.radius = STRONG_RADIUS
		attack_mesh.mesh.top_radius = STRONG_RADIUS
		attack_mesh.mesh.bottom_radius = STRONG_RADIUS
func exit() -> void:
	animation_player.stop()
	collision_shape_3d.debug_color = Color("0099b36b")
	collision_shape_3d.global_position = parent.position
	attack_mesh.global_position = parent.position
	attack_mesh.visible = false
	attack_hitbox.monitoring = false
	animation_player.animation_finished.disconnect(_on_animation_player_animation_finished)
	attack_hitbox.body_entered.disconnect(_on_attack_hitbox_body_entered)
