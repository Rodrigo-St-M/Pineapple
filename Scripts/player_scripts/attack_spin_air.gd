extends PlayerState

@onready var animation_player: AnimationPlayer = $"../../AnimationPlayer"
@onready var collision_shape_3d: CollisionShape3D = $"../../AttackHitbox/CollisionShape3D"
@onready var attack_hitbox: Area3D = $"../../AttackHitbox"
@onready var attack: Node = $"../AttackSpin"
@onready var attack_mesh: MeshInstance3D = $"../../AttackHitbox/AttackMesh"


const WEAK_RADIUS : float = 1.3
const MEDIUM_RADIUS : float = 1.6
const STRONG_RADIUS : float = 1.9
const TURN_STRENGTH: int = 8

const DMG : int = 3

#var input_released : bool
var y_velocity
var can_start_end : bool
var is_finished : bool

func enter() -> void:
	parent.set_collision_mask_value(3, false)
	y_velocity = parent.velocity.y
	attack_mesh.visible = true
	#input_released = false
	is_finished = false
	collision_shape_3d.shape = CylinderShape3D.new()
	collision_shape_3d.shape.height = 1.0
	
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
		
	if enter_args.size() == 1 && !enter_args[0]:
		can_start_end = true
		animation_player.play("attack_spin_loop")
	else:
		can_start_end = false
		animation_player.play("attack_spin_start")

func exit() -> void:
	parent.set_collision_mask_value(3, true)
	attack_mesh.visible = false
	animation_player.stop()
	collision_shape_3d.debug_color = Color("0099b36b")
	attack_hitbox.monitoring = false
	

func process_physics(delta: float) -> State:
	var state : PlayerState = null
	if y_velocity < 0 && parent.is_on_floor():
			state = attack
			state.enter_args = [false]
			
	#if can_start_end && input_released:
		#animation_player.play("attack_spin_end")
		#can_start_end = false
	
	# update y_velocity
	y_velocity = y_velocity - (delta * parent.get_gravity().length() * 2)
	
	#if !Input.is_action_pressed("attack"):
		#input_released = true
	
	var collision : KinematicCollision3D = parent.move_and_collide(parent.velocity * delta, true)
	if collision != null && !parent.is_on_floor():
		
		parent.velocity.y = y_velocity
		parent.move_and_collide(parent.velocity * delta)
		parent.velocity = parent.velocity.bounce(collision.get_normal())
		parent.move_and_collide(collision.get_remainder())
	else:
		var input_dir = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down").normalized()
		input_dir = Vector3(input_dir.x, 0.0, input_dir.y)
		
		if speed_curve_in < 0.04 :
			parent.velocity = parse_movement_input(input_dir, delta, 
					clamp(TURN_STRENGTH * delta *(1/parent.velocity.length()), 0, 1), false)
		else:
			parent.velocity = parse_movement_input(input_dir, delta, 
					clamp(TURN_STRENGTH * delta *(1/parent.velocity.length()), 0, 1), true)
		parent.velocity.y = y_velocity
		
		parent.move_and_slide()
	return state

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "attack_spin_start":
		animation_player.play("attack_spin_loop")
