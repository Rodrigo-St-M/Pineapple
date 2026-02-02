extends PlayerState

const TURN_STRENGHT : int = 50
const BRAKE_STRENGHT : int = 1
const MIN_VELOCITY : float = 0.0004
@export var idleState : State
@export var attackState : State
@export var bumpState : State

func enter() -> void :
	parent.move_and_slide()
	
func exit() -> void :
	pass
	
func process_physics(delta : float) -> State :
	var input_dir = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down").normalized()
	input_dir = Vector3(input_dir.x, 0.0, input_dir.y)
	parse_movement_input(input_dir, delta,
			clamp(TURN_STRENGHT * delta *(1/parent.velocity.length()), 0, 1), false)

	var state = null

	if speed_curve_in < 0.00001:
		state = idleState
	
	# collision handling
	var collision : KinematicCollision3D = parent.move_and_collide(parent.velocity * delta, true)
	if collision != null && parent.velocity.normalized().dot(collision.get_normal()) < -0.87 && parent.get_real_velocity().length() > 7:
		parent.move_and_collide(parent.velocity * delta)
		state = bumpState
		speed_curve_in = 0.0
	
	else:
		parent.move_and_slide()

	return state

func process_input(_event : InputEvent) -> State :
	if Input.is_action_just_pressed("attack"):
		return attackState
	return null
