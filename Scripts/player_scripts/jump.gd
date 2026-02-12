extends PlayerState

var time : float
const START_JUMP_SPEED : int = 7
const TURN_STRENGTH : int = 32

var y_velocity : float

@onready var fall: Node = $"../Fall"

func enter() -> void :
	y_velocity = START_JUMP_SPEED
	time = 0

func process_physics(delta: float) -> State:
	var state : PlayerState = null

	var input_dir = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down").normalized()
	time += delta
	input_dir = Vector3(input_dir.x, 0.0, input_dir.y)
	parent.velocity = parse_movement_input(input_dir, delta, 
			clamp(TURN_STRENGTH * delta *(1/parent.velocity.length()), 0, 1), true)
	
	if Input.is_action_pressed("jump") :
		y_velocity = y_velocity - (delta * parent.get_gravity().length())
	else :
		y_velocity = y_velocity - (delta * parent.get_gravity().length() * 2)
	parent.velocity.y = y_velocity
	
	parent.move_and_slide()
	if y_velocity < 0:
		state = fall
	
	return state
