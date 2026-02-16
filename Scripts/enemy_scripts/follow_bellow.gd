extends State

const STACKER_HEIGHT: float = 1.2
var new_position: Vector3
func process_physics(_delta: float) -> State:
	if parent.piece_below:
		new_position = parent.piece_below.position
		new_position.y += STACKER_HEIGHT
		parent.position = new_position
		parent.velocity = parent.piece_below.velocity
	parent.move_and_slide()
	return null
