extends State

var tower: Array
var SPEED : int = 2
var direction : Vector3
var pineapple_tree : StaticBody3D

@onready var escape_stacker: State = $"../Escape"

func enter() -> void :
	pineapple_tree = parent.pineapple_tree
	tower = parent.tower

func process_physics(_delta: float) -> State:
	parent.velocity = SPEED * direction
	direction = (pineapple_tree.global_position - parent.global_position)
	direction.y = 0.0
	direction = direction.normalized()
	
	parent.move_and_slide()
	for i in parent.get_slide_collision_count():
		var collider : Object = parent.get_slide_collision(i).get_collider()
		if collider.get_instance_id() == pineapple_tree.get_instance_id():
			tower[0].holding_pineapple = pineapple_tree.call("steal_pineapple")
		if tower[0].holding_pineapple:
			tower[0].add_child( tower[0].holding_pineapple )
			return escape_stacker
	
	return null
