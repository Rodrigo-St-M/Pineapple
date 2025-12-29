extends State

@export var idleState : State
@export var attackState : State

const SPEED_MULT := 15
@export var SPEED_CURVE : Curve

func enter() -> void :
	pass
func exit() -> void :
	pass
	
func process_physics(delta : float) -> State :
	var input_dir := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	var direction := ( Vector3(input_dir.x, 0, input_dir.y)).normalized()
	var state = null
	if direction:
		# player is inputting direction
		if speed_curve_in > 2:
			speed_curve_in = 2.0
		if (direction + parent.velocity.normalized()).length() < 0.25 :
			# if player is braking
			parent.velocity = parent.velocity.normalized() * SPEED_CURVE.sample(speed_curve_in) * SPEED_MULT
			speed_curve_in = ( speed_curve_in / (1 + delta * 10) ) - delta * 0.01
		else :
			# if player is inputing a direction
			parent.velocity = parent.velocity.normalized().lerp(direction, 0.15) * SPEED_CURVE.sample(speed_curve_in) * SPEED_MULT
			speed_curve_in += delta / 5.0
	else:
		# if there's no input but player is still moving
		parent.velocity = parent.velocity.normalized() * SPEED_CURVE.sample(speed_curve_in) * SPEED_MULT
		speed_curve_in -= delta
		
	parent.move_and_slide()
	if speed_curve_in < 0.001:
		speed_curve_in = 0.001
		state = idleState
	return state

func process_input(event : InputEvent) -> State :
	if Input.is_action_just_pressed("attack"):
		return attackState
	return null

func process_frame(delta : float) -> State :
	return null
