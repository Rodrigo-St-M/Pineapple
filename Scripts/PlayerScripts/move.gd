extends State

@export var idleState : State
@export var attackState : State
@export var bumpState : State

const SPEED_MULT := 15
@export var SPEED_CURVE : Curve
var test : bool = false
var direction : Vector3
func enter() -> void :
	parent.move_and_slide()
	
func exit() -> void :
	pass
	
func process_physics(delta : float) -> State :
	var input_dir := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	direction = ( Vector3(input_dir.x, 0, input_dir.y)).normalized()
	var state = null
	if direction:
		# player is inputting direction
		if (direction + parent.get_last_motion().normalized()).length() < 0.25 :
			# if player is braking, i.e, inputing a direction opposite of celocity
			parent.velocity = parent.get_real_velocity().normalized() * SPEED_CURVE.sample(speed_curve_in) * SPEED_MULT
			speed_curve_in = ( speed_curve_in / (1 + delta * 10) ) - delta * 0.01
			if speed_curve_in < 0.003:
				parent.velocity = -parent.velocity
		else :
			# if player is inputing a direction
			parent.velocity = parent.get_last_motion().normalized().lerp(direction, 0.15) * SPEED_CURVE.sample(speed_curve_in) * SPEED_MULT
			parent.velocity.y = 0
			speed_curve_in += delta / 5.0
	else:
		# if there's no input but player is still moving
		parent.velocity = parent.get_last_motion().normalized() * SPEED_CURVE.sample(speed_curve_in) * SPEED_MULT
		speed_curve_in -= delta
		
	if speed_curve_in > 2:
		speed_curve_in = 2.0
	if speed_curve_in < 0.001:
		speed_curve_in = 0.001
		state = idleState
	
	# collision handling
	var collision : KinematicCollision3D = parent.move_and_collide(parent.get_real_velocity() * delta, true)
	if collision != null && parent.get_real_velocity().normalized().dot(collision.get_normal()) < -0.87 && parent.get_real_velocity().length() > 7:
		parent.move_and_collide(parent.velocity * delta)
		state = bumpState
		speed_curve_in = 0.001
	else:
		parent.move_and_slide()
		
	return state

func process_input(_event : InputEvent) -> State :
	if Input.is_action_just_pressed("attack"):
		return attackState
	return null
