extends State

const START_IMPACT_SPEED: int = 3
const TIME_AFTER_LANDING: int = 2
const DAMP_STRENGTH: int = 4
var time: float

@onready var chase: Node = $"../Chase"


func enter() -> void :
	parent.velocity = -parent.velocity.normalized() * START_IMPACT_SPEED
	parent.velocity.y = START_IMPACT_SPEED
	
	time = 0
	

func process_physics(_delta: float) -> State:
	var state: State = null

	parent.move_and_slide()
	
	if parent.is_on_floor():
		parent.velocity.y = 0
		parent.velocity = lerp(parent.velocity, Vector3.ZERO, DAMP_STRENGTH * _delta)
		time += _delta
		if time >= TIME_AFTER_LANDING:
			parent.velocity = -parent.velocity
			state = chase
			
	else:
		parent.velocity.y -= _delta * parent.get_gravity().length()
	return state
