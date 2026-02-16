extends PlayerState
const TURN_STRENGHT : int = 14
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var collision_shape_3d: CollisionShape3D = $Area3D/CollisionShape3D
@onready var area_3d: Area3D = $Area3D


@onready var jump: Node = $"../Jump"
@export var idleState : State
@export var moveState : State
const WEAK_RADIUS : float = 1.3
const MEDIUM_RADIUS : float = 1.6
const STRONG_RADIUS : float = 1.9


const DMG : int = 3

var input_released : bool
var can_start_end : bool
var is_finished : bool

func enter() -> void :
	input_released = false
	is_finished = false
	can_start_end = false
	collision_shape_3d.shape = CylinderShape3D.new()
	collision_shape_3d.shape.height = 1.0
	if parent.velocity.length() < NORMAL_SPEED_TRESHOLD:
		collision_shape_3d.shape.radius = WEAK_RADIUS
	elif parent.velocity.length() < STRONG_SPEED_TRESHOLD:
		collision_shape_3d.shape.radius = MEDIUM_RADIUS
	else:
		collision_shape_3d.shape.radius = STRONG_RADIUS
	animation_player.play("attack_spin_start")

func exit() -> void:
	animation_player.stop()
	collision_shape_3d.debug_color = Color("0099b36b")
	area_3d.monitoring = false
	
func process_input(_event: InputEvent) -> State:
	if _event.is_action_released("attack"):
		input_released = true
	if Input.is_action_pressed("jump"):
		return jump
	return null

func process_physics(delta: float) -> State:
	var state : PlayerState = null
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
	else :
		var input_dir = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down").normalized()
		input_dir = Vector3(input_dir.x, 0.0, input_dir.y)
		parent.velocity = parse_movement_input(input_dir, delta,
				clamp(TURN_STRENGHT * delta *(1/parent.velocity.length()), 0, 1), true)
		parent.move_and_slide()
	return state

func _on_area_3d_body_entered(body: Node3D) -> void:
	if body is Enemy:
		var enemy : Enemy = body
		enemy.call("damaged", DMG)

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
