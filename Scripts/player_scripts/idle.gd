extends PlayerState

@onready var move: Node = $"../Move"
@onready var attack: Node = $"../Attack"
@onready var jump: Node = $"../Jump"
@onready var fall: Node = $"../Fall"





func enter() -> void :
	parent.velocity = Vector3.ZERO
	speed_curve_in = 0
	
func process_input(_event: InputEvent) -> State:

	if ( Input.is_action_pressed("ui_down") || Input.is_action_pressed("ui_up")
		|| Input.is_action_pressed("ui_left") || Input.is_action_pressed("ui_right") ):
		return move
	
	if Input.is_action_pressed("attack"):
		return attack
	
	if Input.is_action_pressed("jump"):
		return jump
	return null

func process_physics(_delta: float) -> State:
	var state: PlayerState = null
	
	if !parent.is_on_floor():
		state = fall
	
	return state
