extends State
class_name PlayerState
const SPEED_CURVE : Curve = preload("uid://b3wu0djn28s0i")
const SPEED_CURVE_REVERSE : Curve = preload("uid://bosq1xrfqh674")
const SPEED_MULT : float = 15
const MIN_SPEED_CURVE_IN_TO_FLIP : float = 0.003
# input for speed curve. Must be preserved between states
static var speed_curve_in : float = 0.0

## Processes player's current velocity and speed_in given player input 
## and previous frame's velocity.
## Does not process collisions nor move the player itself
## [input] the given player input as a normalized vector3
## [delta] the elapsed time since last frame
## [turn_strength] how quickly the player turn towards input direction. 
## Must be a value between 1 and 0.
## [is_accelerate] if speed_in should not be changed and just vary 
## velocity's direction, defaults as true
func parse_movement_input(input_direction : Vector3, delta : float, turn_strength : float,
		 just_turn : bool = true, brake_strenght : float = 1.0) -> void:
	# player is inputting direction
	#print(input_direction)
	if input_direction:
		# if player is braking, i.e, inputing a direction opposite of velocity
		if !just_turn && (input_direction.dot(parent.get_real_velocity().normalized())) < -0.67 :
			parent.velocity = parent.get_real_velocity().normalized() * SPEED_CURVE.sample(speed_curve_in) * SPEED_MULT
			speed_curve_in = ( speed_curve_in / (1 + delta * 10) ) - delta * 0.01
			if speed_curve_in < MIN_SPEED_CURVE_IN_TO_FLIP:
				parent.velocity = -parent.velocity
		# if player is inputing a direction and not braking
		else :
			parent.velocity = parent.get_real_velocity().normalized().lerp(input_direction, turn_strength) * SPEED_CURVE.sample(speed_curve_in) * SPEED_MULT
			parent.velocity.y = 0
			speed_curve_in += (delta / 5.0)
	
	# if there's no input but player is still moving
	else:
		parent.velocity = parent.get_real_velocity().normalized() * SPEED_CURVE.sample(speed_curve_in) * SPEED_MULT
		speed_curve_in -= delta
		
	if speed_curve_in > SPEED_CURVE.max_domain:
		speed_curve_in = SPEED_CURVE.max_domain
	if speed_curve_in < 0.0:
		speed_curve_in = 0.0
