extends State

@export var next_state : State

func enter() -> void:
	parent.velocity = Vector3(0,-(parent.position.y), 0)
	parent.set_collision_mask_value(1, false)

func process_physics(_delta: float) -> State:
	parent.velocity.y = move_toward(parent.velocity.y, 0, _delta * 5)
	parent.move_and_slide()

	if parent.is_on_floor() && parent.position.y < 1.1:
		parent.set_collision_mask_value(1, true)
		return next_state
	return null
