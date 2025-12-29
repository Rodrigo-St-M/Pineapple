extends State
var player : CharacterBody3D
var SPEED : int = 5
#how many physics frames to recalculate direction
var DIRECTION_PERIOD : int = 10
var count : int
func enter() -> void :
	player = get_tree().get_first_node_in_group("Player")
	print(player)
	count = DIRECTION_PERIOD
	
func process_physics(delta: float) -> State:
	var direction : Vector3
	
	if count == 0 :
		direction = (parent.position - player.position).normalized()
		count = DIRECTION_PERIOD
		
	parent.velocity = SPEED * direction
	parent.move_and_slide()
	count -= 1
	return null
