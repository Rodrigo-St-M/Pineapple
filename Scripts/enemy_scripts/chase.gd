extends State
var SPEED : int = 4
#how many physics iterations to recalculate direction
const DIRECTION_PERIOD : int = 60
var count : int
var direction : Vector3

var player : CharacterBody3D

func enter() -> void :
	player = parent.player
	if player == null:
		print("whoops")
	count = randi_range(1,DIRECTION_PERIOD)
	
func process_physics(delta: float) -> State:
	
	if count == 0 :
		direction = (player.position + player.velocity - parent.position).normalized()
		count = DIRECTION_PERIOD
		
	parent.velocity = SPEED * direction
	
	# we use move and collide instead of move and slide so enemies dont slide
	# above each other and stick to the ground
	parent.move_and_collide(parent.velocity * delta)
	count -= 1 
	return null
