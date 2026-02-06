extends State

var SPEED : int = 2

var direction : Vector3
var pineapple_tree : StaticBody3D
@export var escape_state : State

func enter() -> void :
	pineapple_tree = parent.pineapple_tree
	direction = (pineapple_tree.global_position - parent.global_position)
	direction.y = 0.0
	direction = direction.normalized()

func process_physics(delta: float) -> State:
	parent.velocity = SPEED * direction
	# we use move and collide instead of move and slide so enemies dont slide
	# above each other and stick to the ground
	var collision = parent.move_and_collide(parent.velocity * delta)
	if collision && collision.get_collider_id() == pineapple_tree.get_instance_id():
		parent.holding_pineapple = pineapple_tree.call("steal_pineapple")
		
		if parent.holding_pineapple:
			parent.add_child( parent.holding_pineapple )
			return escape_state
	return null
