extends State

var time : float
const START_IMPACT_SPEED : int = 5
const FALL_SPEED : int = 9
var direction : Vector3

func enter() -> void :
	time = 0
	direction = - (parent.player.position - parent.position).normalized()
	direction *= (START_IMPACT_SPEED 
			+ direction.dot(parent.player.velocity.normalized()) * parent.player.velocity.length())
	parent.collision_mask = 16
	parent.collision_layer = 0

func process_physics(delta: float) -> State:
	time += delta * FALL_SPEED
	direction.y = START_IMPACT_SPEED - time
	parent.velocity = direction
	
	parent.move_and_slide()
	
	if parent.is_on_floor() :
		exit()
	return null

func exit() -> void:
	parent.queue_free()
