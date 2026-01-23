extends State

var FLOOR_Y = 1
var time : float
const START_IMPACT_SPEED : int = 5
const FALL_SPEED : int = 15
var direction : Vector3
@export var moveState : State

func enter() -> void :
	direction = -parent.get_last_motion().normalized() * START_IMPACT_SPEED
	direction.y = START_IMPACT_SPEED
	time = 0

func process_physics(delta: float) -> State:
	direction.y -= delta * FALL_SPEED
	parent.velocity = direction
	time += delta
	parent.move_and_slide()
	
	if parent.position.y < FLOOR_Y :
		parent.position.y = FLOOR_Y
		time = 0
		return moveState
	return null
