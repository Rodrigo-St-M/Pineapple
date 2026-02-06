extends State

const MIN_ESCAPE_DISTANCE : int = 18
var SPEED : int = 2
#how many physics iterations to recalculate direction
var direction : Vector3
var pineapple_tree : StaticBody3D
@export var aproach_state : State


func enter() -> void :
	print("escaping")
	pineapple_tree = parent.pineapple_tree
	direction = (-pineapple_tree.position + parent.position)
	direction.y = 0
	direction = direction.normalized()


func process_physics(delta: float) -> State:
	parent.velocity = SPEED * direction
	# we use move and collide instead of move and slide so enemies dont slide
	# above each other and stick to the ground
	var collision = parent.move_and_collide(parent.velocity * delta)
	if collision && (pineapple_tree.position - parent.position).length() > 18:
		return aproach_state
	return null
