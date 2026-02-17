extends PlayerState

const START_JUMP_SPEED : int = 10
const TURN_STRENGTH : int = 26

var time : float
var y_velocity : float

@onready var fall: Node = $"../Fall"
@onready var attack_spin_air: Node = $"../AttackSpinAir"

func enter() -> void :
	y_velocity = START_JUMP_SPEED

func process_input(_event : InputEvent) -> State :
	if Input.is_action_just_pressed("attack"):
		return attack_spin_air
	else:
		return null

func process_physics(delta: float) -> State:
	var state : PlayerState = null
	
	var input_dir = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down").normalized()
	input_dir = Vector3(input_dir.x, 0.0, input_dir.y)
	
	if speed_curve_in < 0.08 :
		parent.velocity = parse_movement_input(input_dir, delta, 
				clamp(TURN_STRENGTH * delta *(1/parent.velocity.length()), 0, 1), false)
	else:
		parent.velocity = parse_movement_input(input_dir, delta, 
				clamp(TURN_STRENGTH * delta *(1/parent.velocity.length()), 0, 1), true)
		speed_curve_in = speed_curve_in - (speed_curve_in * delta)
	if Input.is_action_pressed("jump") :
		y_velocity = y_velocity - (delta * parent.get_gravity().length() * 2)
	else :
		y_velocity = y_velocity - (delta * parent.get_gravity().length() * 3)
	parent.velocity.y = y_velocity
	
	parent.move_and_slide()
	if y_velocity < 0:
		state = fall
	
	return state
