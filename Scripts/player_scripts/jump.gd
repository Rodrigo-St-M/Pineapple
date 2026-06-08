extends PlayerState

const START_JUMP_SPEED : int = 10
const TURN_STRENGTH : int = 26

var time : float
var y_velocity : float

@onready var fall: Node = $"../Fall"
@onready var bump: Node = $"../Bump"

func enter() -> void :
	y_velocity = START_JUMP_SPEED

func process_input(_event : InputEvent) -> State :
	var attacks : Array[PlayerState.Attacks] = parent.attacks
	var state : PlayerState = null
	if Input.is_action_just_pressed("attack0") && attacks.size() > 0:
		state = get_node_or_null("../Attack0")
	if Input.is_action_just_pressed("attack1") && attacks.size() > 1:
		state = get_node_or_null("../Attack1")
	if Input.is_action_just_pressed("attack2") && attacks.size() > 2:
		state = get_node_or_null("../Attack1")
	return state

func process_physics(delta: float) -> State:
	var state : PlayerState = null
	
	var input_dir = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down").normalized()
	input_dir = Vector3(input_dir.x, 0.0, input_dir.y)
	
	if speed_curve_in < 0.08 :
		parent.velocity = parse_movement_input(input_dir, delta, 
				clamp(TURN_STRENGTH * delta *(1/parent.velocity.length()), 0, 1), false)
	else:
		parent.velocity = parse_movement_input(input_dir, delta, 
				clamp(TURN_STRENGTH * delta *(1/parent.velocity.length()), 0, 1), true)
		#speed_curve_in = speed_curve_in - (speed_curve_in * delta)
	if Input.is_action_pressed("jump") :
		y_velocity = y_velocity - (delta * parent.get_gravity().length() * 2)
	else :
		y_velocity = y_velocity - (delta * parent.get_gravity().length() * 3)
	parent.velocity.y = y_velocity
	
	var collision : KinematicCollision3D = parent.move_and_collide(parent.velocity * delta, true)
	if collision != null && parent.velocity.normalized().dot(collision.get_normal()) < -0.87 && parent.get_real_velocity().length() > 7:
		parent.move_and_collide(parent.velocity * delta)
		state = bump
	else:
		parent.move_and_slide()
	
	if y_velocity < 0:
		state = fall
	
	return state
