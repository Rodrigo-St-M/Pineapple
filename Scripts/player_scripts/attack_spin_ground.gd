extends PlayerState
# enter_args[0] should be a bool that says if the start_animation of the attack should be played (true)
# or skipped (false), if enter_args[0] does not exist, is not a bool or is not null, it will be treated
# as true 

@onready var animation_player: AnimationPlayer = $"../../AnimationPlayer"
@onready var collision_shape_3d: CollisionShape3D = $"../../AttackHitbox/CollisionShape3D"
@onready var attack_hitbox: Area3D = $"../../AttackHitbox"
@onready var attack_mesh: MeshInstance3D = $"../../AttackHitbox/AttackMesh"

@onready var jump: State = $"../Jump"

@onready var attack_spin_air: State = $"../AttackSpinAir"
@export var idleState : State
@export var moveState : State

const WEAK_RADIUS : float = 1.3
const MEDIUM_RADIUS : float = 1.6
const STRONG_RADIUS : float = 1.9
const START_JUM_SPEED_MID_ATTACK: int = 10
const TURN_STRENGTH : int = 14


const DMG : int = 3

var input_released : bool
var can_start_end : bool
var is_finished : bool

func enter() -> void :
	input_released = false
	is_finished = false
	attack_mesh.visible = true
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
	animation_player.stop()
	collision_shape_3d.debug_color = Color("0099b36b")
	attack_mesh.visible = false
	attack_hitbox.monitoring = false
	
func process_input(_event: InputEvent) -> State:
	#if _event.is_action_released("attack"):
		#input_released = true
	if Input.is_action_pressed("jump"):
		if input_released:
			return jump
		else:
			attack_spin_air.enter_args = [false]
			parent.velocity.y = START_JUM_SPEED_MID_ATTACK
			#print("air_attack")
			return attack_spin_air
	return null

func process_physics(delta: float) -> State:
	var state : PlayerState = null
	
	if !Input.is_action_pressed("attack"):
		input_released = true
	
	if is_finished:
		if parent.velocity.length() < 0.001 :
			state = idleState
		else :
			state = moveState
	if can_start_end && input_released:
		animation_player.play("attack_spin_end")
		can_start_end = false
		
	var collision : KinematicCollision3D = parent.move_and_collide(parent.velocity * delta, true)
	if collision != null:
		parent.move_and_collide(parent.velocity * delta).get_remainder()
		parent.velocity = parent.velocity.bounce(collision.get_normal())
		parent.move_and_collide(collision.get_remainder())
	else:
		var input_dir = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down").normalized()
		input_dir = Vector3(input_dir.x, 0.0, input_dir.y)
		
		if speed_curve_in < 0.06 :
			parent.velocity = parse_movement_input(input_dir, delta, 
					clamp(TURN_STRENGTH * delta *(1/parent.velocity.length()), 0, 1), false)
		else:
			parent.velocity = parse_movement_input(input_dir, delta, 
					clamp(TURN_STRENGTH * delta *(1/parent.velocity.length()), 0, 1), true)
		parent.move_and_slide()
	return state

func _on_attack_hitbox_body_entered(body: Node3D) -> void:
	if body is Enemy:
		var enemy : Enemy = body
		enemy.call("damaged", DMG, parent.position)

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "attack_spin_start":
		#print("start just finished")
		if input_released:
			animation_player.play("attack_spin_end")
		else:
			animation_player.play("attack_spin_loop")
		can_start_end = true
	if anim_name == "attack_spin_end":
		#print("end just finished")
		is_finished = true
