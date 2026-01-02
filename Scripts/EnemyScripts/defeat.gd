extends State

var time : float
const START_IMPACT_SPEED : int = 5
const FALL_SPEED : int = 9
var direction : Vector3

func enter() -> void :
	super()
	time = 0
	direction = - (parent.player.position - parent.position).normalized() * 5

func process_physics(delta: float) -> State:
	time += delta * FALL_SPEED
	direction.y = START_IMPACT_SPEED - time
	parent.velocity = direction
	
	parent.move_and_slide()
	
	if parent.position.y < 0.636 :
		parent.queue_free()
	return null
