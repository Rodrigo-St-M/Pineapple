extends PlayerState

@onready var animation_player: AnimationPlayer = $"../../../AnimationPlayer"
@onready var collision_shape_3d: CollisionShape3D = $"../../../AttackHitbox/CollisionShape3D"
@onready var attack_hitbox: Area3D = $"../../../AttackHitbox"
@onready var attack_mesh: MeshInstance3D = $"../../../AttackHitbox/AttackMesh"
@onready var fall: PlayerState = $"../../Fall"

const START_JUMP_SPEED : int = 20
const TURN_STRENGTH : int = 64
const DMG : int = 3

var y_velocity : float

func enter() -> void:
	var horiz_vel = Vector3(parent.velocity.x, 0.0, parent.velocity.z)
	attack_hitbox.body_entered.connect(_on_attack_hitbox_body_entered)
	y_velocity = START_JUMP_SPEED
	attack_mesh.visible = true
	collision_shape_3d.shape = CylinderShape3D.new()
	collision_shape_3d.shape.height = 2.0
	collision_shape_3d.shape.radius = 1.0
	attack_mesh.mesh.height = 3.0
	attack_mesh.mesh.top_radius = 1.0
	attack_mesh.mesh.bottom_radius = 1.0
	collision_shape_3d.position = horiz_vel.normalized()
	attack_mesh.position = horiz_vel.normalized()
	animation_player.play("uppercut_ground_start")

func process_physics(_delta: float) -> State:
	var state: PlayerState = null
	var horiz_vel = Vector3(parent.velocity.x, 0.0, parent.velocity.z)
	var input_dir = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down").normalized()
	input_dir = Vector3(input_dir.x, 0.0, input_dir.y)
	
	if speed_curve_in < 0.08 :
		parent.velocity = parse_movement_input(input_dir, _delta, 
				clamp(TURN_STRENGTH * _delta *(1/parent.velocity.length()), 0, 1), false)
	else:
		parent.velocity = parse_movement_input(input_dir, _delta, 
				clamp(TURN_STRENGTH * _delta *(1/parent.velocity.length()), 0, 1), true)
	
	collision_shape_3d.position = horiz_vel.normalized()
	attack_mesh.position = horiz_vel.normalized()
	
	y_velocity = y_velocity - (_delta * parent.get_gravity().length() * 6)
	parent.velocity.y = y_velocity
	
	parent.move_and_slide()
	
	if y_velocity < 0:
		state = fall
	
	return state

func _on_attack_hitbox_body_entered(body: Node3D) -> void:
	if body is Enemy:
		var enemy : Enemy = body
		enemy.call("damaged", DMG, parent.position)
		
func exit() -> void:
	animation_player.stop()
	collision_shape_3d.debug_color = Color("0099b36b")
	collision_shape_3d.global_position = parent.position
	attack_mesh.global_position = parent.position
	attack_mesh.visible = false
	attack_hitbox.monitoring = false
	attack_hitbox.body_entered.disconnect(_on_attack_hitbox_body_entered)
