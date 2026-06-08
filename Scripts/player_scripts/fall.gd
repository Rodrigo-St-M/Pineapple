extends PlayerState

var time : float
const TURN_STRENGTH : int = 26

var y_velocity : float

@onready var idle: Node = $"../Idle"
@onready var move: Node = $"../Move"
@onready var jump: Node = $"../Jump"
@onready var bump: Node = $"../Bump"

func enter() -> void :
	y_velocity = 0
	time = 0
	parent.set_collision_mask_value(3, false)

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
	time += delta
	input_dir = Vector3(input_dir.x, 0.0, input_dir.y)
	
	if speed_curve_in < 0.08 :
		parent.velocity = parse_movement_input(input_dir, delta, 
				clamp(TURN_STRENGTH * delta * (1/parent.velocity.length()), 0, 1), false)
	else:
		parent.velocity = parse_movement_input(input_dir, delta, 
				clamp(TURN_STRENGTH * delta * (1/parent.velocity.length()), 0, 1), true)
		speed_curve_in = speed_curve_in - (speed_curve_in * delta)
	
	if Input.is_action_pressed("jump") :
		y_velocity = y_velocity - (delta * parent.get_gravity().length() * 2)
	else :
		y_velocity = y_velocity - (delta * parent.get_gravity().length() * 4)
	parent.velocity.y = y_velocity
	
	
	var horiz_vel = Vector3(parent.velocity.x, 0.0, parent.velocity.y)
	if parent.is_on_floor():
		for i in parent.get_slide_collision_count():
			var collider : Object = parent.get_slide_collision(i).get_collider()
			if collider.is_class("CharacterBody3D"):
				#print("ENEMY!")
				collider.call("damaged", 2)
			elif horiz_vel.length() < 0.001:
				state = idle
			else:
				state = move
	else:
		var collision : KinematicCollision3D = parent.move_and_collide(parent.velocity * delta, true)
		if collision != null && horiz_vel.normalized().dot(collision.get_normal()) < -0.87 && parent.get_real_velocity().length() > 7:
			parent.move_and_collide(parent.velocity * delta)
			state = bump
		else:
			parent.move_and_slide()
	return state

func exit() -> void:
	parent.set_collision_mask_value(3, true)
