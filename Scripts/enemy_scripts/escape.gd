extends State

const MIN_ESCAPE_DISTANCE : int = 18
var SPEED : int = 2
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


func process_physics(delta: float) -> State:
	# we use move and collide instead of move and slide so enemies dont slide
	# above each other and stick to the ground
	var collision = parent.move_and_collide(parent.velocity * delta)
	if collision && (pineapple_tree.position - parent.position).length() > 18:
		emit_signal("pineapple_lost")
		GameMaster.lives_left -= 1
		parent.holding_pineapple.queue_free()
		return aproach_state
	return null
