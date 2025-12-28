extends State
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@export var idleState : State
@export var moveState : State

func enter() -> void :
	print("attack start")
	animation_player.play("attack_spin")
	
func process_input(event: InputEvent) -> State:
		return null

func process_physics(delta: float) -> State:
	if !animation_player.is_playing() :
		print("attack end")
		if parent.velocity.length() < 0.001 :
			return idleState
		else :
			return moveState
	parent.move_and_slide()
	return null
