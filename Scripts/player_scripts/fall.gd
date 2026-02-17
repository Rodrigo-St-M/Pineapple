extends PlayerState

var time : float
const TURN_STRENGTH : int = 26

var y_velocity : float

@onready var idle: Node = $"../Idle"
@onready var move: Node = $"../Move"
@onready var jump: Node = $"../Jump"
@onready var attack_spin_air: Node = $"../AttackSpinAir"

func enter() -> void :
	y_velocity = 0
	time = 0
	parent.set_collision_mask_value(3, false)

func process_input(_event : InputEvent) -> State :
	if Input.is_action_just_pressed("attack"):
		return attack_spin_air
	else:
		return null

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
	
	parent.move_and_slide()
	
	if parent.is_on_floor():
		
		for i in parent.get_slide_collision_count():
			var collider : Object = parent.get_slide_collision(i).get_collider()
			if collider.is_class("CharacterBody3D"):
				print("ENEMY!")
				collider.call("damaged", 2)
			elif Vector3(parent.velocity.x, 0.0, parent.velocity.y).length() < 0.001:
				state = idle
			else:
				state = move
	return state

func exit() -> void:
	parent.set_collision_mask_value(3, true)
