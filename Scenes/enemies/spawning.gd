extends State

@export var next_state : State

func enter() -> void:
	parent.velocity = Vector3(0,-(parent.position.y / 2), 0)

func process_physics(_delta: float) -> State:
	parent.velocity.y = move_toward(parent.velocity.y, 0, _delta * 1.2)
	parent.move_and_slide()

	if parent.is_on_floor():
		return next_state
	return null
