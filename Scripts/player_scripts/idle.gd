extends PlayerState

@export var moveState : State
@export var attackState : State

func enter() -> void :
	parent.velocity = Vector3.ZERO
	speed_curve_in = 0
	
func process_input(_event: InputEvent) -> State:
	if Input.is_action_pressed("ui_down") || Input.is_action_pressed("ui_up") || Input.is_action_pressed("ui_left") || Input.is_action_pressed("ui_right"):
		return moveState
	if Input.is_action_pressed("attack"):
		return attackState
	return null

func process_physics(_delta: float) -> State:
	return null
