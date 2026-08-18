extends State

@export var next_state : State
const START_FALL_SPEED = 5

func enter() -> void:
	parent.velocity = Vector3(0, -START_FALL_SPEED, 0)
	parent.set_collision_layer_value(7, true)
	parent.set_collision_layer_value(3, false)
	parent.set_collision_mask_value(3, false)

func process_physics(_delta: float) -> State:
	parent.move_and_slide()
	parent.look_at_from_position(parent.position, Vector3(0, parent.position.y, 0))
	if parent.is_on_floor() && parent.position.y < 1.1:
		parent.set_collision_mask_value(3, true)
		parent.set_collision_layer_value(3, true)
		parent.set_collision_layer_value(7, false)
		return next_state
	else:
		parent.velocity = Vector3(0, -START_FALL_SPEED, 0)
	return null
