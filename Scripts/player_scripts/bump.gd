extends PlayerState

var time : float
const START_IMPACT_SPEED : int = 5
const FALL_SPEED : int = 15
@export var moveState : State
@onready var jump: Node = $"../Jump"
@onready var move: Node = $"../Move"
@onready var idle: Node = $"../Idle"

func enter() -> void :
	if enter_args.size() == 1:
		parent.velocity = enter_args[0].normalized() * START_IMPACT_SPEED
	else:
		parent.velocity = -parent.get_last_motion().normalized() * START_IMPACT_SPEED
	parent.velocity.y = START_IMPACT_SPEED
	speed_curve_in /= 6
	time = 0
	
func process_physics(delta: float) -> State:
	var state: State = null
	parent.velocity.y -= delta * FALL_SPEED
	parent.move_and_slide()
	time += delta

	if parent.is_on_floor():
		time = 0
		var collider : Object = parent.get_last_slide_collision().get_collider()
		if collider.is_class("CharacterBody3D"):
			#print("ENEMY!")
			collider.call("damaged", 2)
			state = jump
		elif Vector3(parent.velocity.x, 0.0, parent.velocity.y).length() < 0.001:
			state = idle
		else:
			state = move
	return state
