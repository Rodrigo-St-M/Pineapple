extends State

const MIN_ESCAPE_DISTANCE : int = 18
var SPEED : int = 3
var direction : Vector3
var pineapple_tree : StaticBody3D
@export var aproach_state : State
signal pineapple_lost

func enter() -> void :
	print("escaping")
	pineapple_tree = parent.pineapple_tree
	direction = (-pineapple_tree.position + parent.position)
	direction.y = 0
	direction = direction.normalized()
	parent.velocity = SPEED * direction


func process_physics(_delta: float) -> State:
	parent.velocity = SPEED * direction
	parent.move_and_slide()
	for i in parent.get_slide_collision_count():
		var collider : Object = parent.get_slide_collision(i).get_collider()
		if collider && (pineapple_tree.position - parent.position).length() > MIN_ESCAPE_DISTANCE:
			emit_signal("pineapple_lost")
			GameMaster.lives_left -= 1
			parent.holding_pineapple.queue_free()
			return aproach_state
	return null
