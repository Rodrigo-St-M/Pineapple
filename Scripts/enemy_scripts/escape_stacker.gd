extends State
const SPEED : int = 2
const MIN_ESCAPE_DISTANCE : int = 18
var direction : Vector3
var pineapple_tree : StaticBody3D
var tower: Array
@onready var aproach_state: State = $"../Aproach"

func enter() -> void :
	#print("escaping")
	pineapple_tree = parent.pineapple_tree
	direction = (-pineapple_tree.position + parent.position)
	direction.y = 0
	direction = direction.normalized()
	parent.velocity = SPEED * direction
	tower = parent.tower

func process_physics(_delta: float) -> State:
	direction = (-pineapple_tree.position + parent.position)
	direction.y = 0
	direction = direction.normalized()
	parent.velocity = SPEED * direction
	tower = parent.tower
	
	parent.move_and_slide()
	for i in parent.get_slide_collision_count():
		var collider : Object = parent.get_slide_collision(i).get_collider()
		if collider && (pineapple_tree.position - parent.position).length() > MIN_ESCAPE_DISTANCE:
			GameMaster.get_current_instance().pineapple_lost()
			tower[0].holding_pineapple.queue_free()
			return aproach_state
	return null
