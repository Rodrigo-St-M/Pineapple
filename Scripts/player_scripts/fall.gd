extends PlayerState

var time : float
const TURN_STRENGTH : int = 32

var y_velocity : float

@onready var idle: Node = $"../Idle"
@onready var move: Node = $"../Move"
@onready var jump: Node = $"../Jump"

func enter() -> void :
	y_velocity = 0
	time = 0

func process_physics(delta: float) -> State:
	var state : PlayerState = null

	var input_dir = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down").normalized()
	time += delta
	input_dir = Vector3(input_dir.x, 0.0, input_dir.y)
	parent.velocity = parse_movement_input(input_dir, delta, 
			clamp(TURN_STRENGTH * delta *(1/parent.velocity.length()), 0, 1), true)
	#speed_curve_in -= 2 * delta
	if Input.is_action_pressed("jump") :
		y_velocity = y_velocity - (delta * parent.get_gravity().length() * 2)
	else :
		y_velocity = y_velocity - (delta * parent.get_gravity().length() * 4)
	parent.velocity.y = y_velocity
	
	parent.move_and_slide()
	
	if parent.is_on_floor():
		#print(parent.get_last_slide_collision().get_collider().get_class())
		var collider : Object = parent.get_last_slide_collision().get_collider()
		if collider.is_class("CharacterBody3D"):
			print("ENEMY!")
			collider.call("damaged", 2)
			state = jump
		elif Vector3(parent.velocity.x, 0.0, parent.velocity.y).length() < 0.001:
			state = idle
		else:
			state = move
	return state
