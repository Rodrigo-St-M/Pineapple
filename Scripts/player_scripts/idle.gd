extends PlayerState

@onready var move: Node = $"../Move"
@onready var jump: Node = $"../Jump"
@onready var fall: Node = $"../Fall"




func enter() -> void :
	parent.velocity = Vector3.ZERO
	speed_curve_in = 0
	
func process_input(_event: InputEvent) -> State:

	if ( Input.is_action_pressed("ui_down") || Input.is_action_pressed("ui_up")
		|| Input.is_action_pressed("ui_left") || Input.is_action_pressed("ui_right") ):
		return move
	
	var attacks : Array[PlayerState.Attacks] = parent.attacks
	var state : PlayerState = null
	if Input.is_action_just_pressed("attack0") && attacks.size() > 0:
		state = get_node_or_null("../Attack0")
	if Input.is_action_just_pressed("attack1") && attacks.size() > 1:
		state = get_node_or_null("../Attack1")
	if Input.is_action_just_pressed("attack2") && attacks.size() > 2:
		state = get_node_or_null("../Attack2")
	if Input.is_action_just_pressed("jump"):
		state = jump
	return state

func process_physics(_delta: float) -> State:
	var state: PlayerState = null
	
	if !parent.is_on_floor():
		state = fall
	
	return state
