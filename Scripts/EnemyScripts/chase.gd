extends State
var player : CharacterBody3D
var SPEED : int = 4
#how many physics iterations to recalculate direction
var DIRECTION_PERIOD : int = 60
var count : int
var direction : Vector3
func enter() -> void :
	player = get_node("../../../Player")
	print(player)
	count = DIRECTION_PERIOD
	
func process_physics(delta: float) -> State:
	
	if count == 0 :
		direction = (player.position + player.velocity - parent.position).normalized()
		count = DIRECTION_PERIOD
		
	parent.velocity = SPEED * direction
	parent.move_and_slide()
	count -= 1
	return null
