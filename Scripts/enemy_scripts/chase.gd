extends State
var SPEED : int = 3
#how many physics iterations to recalculate direction
const DIRECTION_PERIOD : int = 20
const TURN_STRENGTH : float = 3.0
var count : int
var direction : Vector3

var target : CharacterBody3D

func enter() -> void :
	if parent.next_chaser :
		target = parent.next_chaser
	else:
		target = parent.player
	#chaser_line = parent.chaser_line
	
	if target == null:
		print("whoops")
	count = DIRECTION_PERIOD


func process_physics(_delta: float) -> State:
	if parent.next_chaser :
		target = parent.next_chaser
	else:
		target = parent.player
	
	if count == 0 :
		direction = (target.position - parent.position)
		direction.y = 0
		direction = direction.normalized()
		count = DIRECTION_PERIOD
		
	parent.velocity = lerp(parent.velocity.normalized(), direction, TURN_STRENGTH * _delta) * SPEED
	
	parent.move_and_slide()
	count -= 1 
	return null
