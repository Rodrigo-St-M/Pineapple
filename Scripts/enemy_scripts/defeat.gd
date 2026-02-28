extends State

var time : float
const START_IMPACT_SPEED : int = 5
const FALL_SPEED : int = 9
var direction : Vector3

func enter() -> void :
	GameMaster.get_current_instance().emit_enemy_defeated(parent.type)
	time = 0
	direction = - (parent.player.position - parent.position).normalized()
	direction *= (START_IMPACT_SPEED 
			+ ( direction.dot(parent.player.velocity.normalized()) * parent.player.velocity.length() ) )
	parent.collision_mask = 16
	parent.collision_layer = 0

func process_physics(delta: float) -> State:
	time += delta * FALL_SPEED
	direction.y = START_IMPACT_SPEED - time
	parent.velocity = direction
	
	parent.move_and_slide()
	
	if parent.is_on_floor() :
		#print(str(parent," is on floor, queueing free"))
		parent.queue_free()
	return null
