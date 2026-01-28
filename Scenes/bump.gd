extends State

var time : float
const START_IMPACT_SPEED : int = 5
const FALL_SPEED : int = 15
@export var moveState : State

func enter() -> void :
	parent.velocity = -parent.get_last_motion().normalized() * START_IMPACT_SPEED
	parent.velocity.y = START_IMPACT_SPEED
	time = 0
	print(str(parent.position.y))
	
func process_physics(delta: float) -> State:
	parent.velocity.y -= delta * FALL_SPEED
	time += delta
	parent.move_and_slide()
	
	if parent.is_on_floor():
		time = 0
		return moveState
	return null
