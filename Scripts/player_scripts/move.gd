extends PlayerState

const TURN_STRENGHT : int = 67
const BRAKE_STRENGHT : int = 1
const MIN_VELOCITY : float = 0.0004

@onready var idle_state: PlayerState = $"../Idle"
@onready var attack_state: PlayerState = $"../Attack"
@onready var bump_state: PlayerState = $"../Bump"
@onready var jump_state: PlayerState = $"../Jump"
@onready var fall: Node = $"../Fall"

func enter() -> void :
	##parent.move_and_slide()
	pass
	
func exit() -> void :
	pass
	
func process_physics(delta : float) -> State :
	var state : PlayerState = null
	var input_dir = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down").normalized()
	input_dir = Vector3(input_dir.x, 0.0, input_dir.y)
	parent.velocity = parse_movement_input(input_dir, delta,
			clamp(TURN_STRENGHT * delta *(1/parent.velocity.length()), 0, 1), false)
	

	if speed_curve_in < 0.00001:
		state = idle_state
	
	# collision handling
	var collision : KinematicCollision3D = parent.move_and_collide(parent.velocity * delta, true)
	if collision != null && parent.velocity.normalized().dot(collision.get_normal()) < -0.87 && parent.get_real_velocity().length() > 7:
		parent.move_and_collide(parent.velocity * delta)
		state = bump_state
	
	else:
		parent.move_and_slide()
	
	if !parent.is_on_floor():
		state = fall
	
	return state

func process_input(_event : InputEvent) -> State :
	if Input.is_action_just_pressed("attack"):
		return attack_state
	if Input.is_action_just_pressed("jump"):
		return jump_state
	return null
