extends State
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@export var idleState : State
@export var moveState : State

const DMG : int = 3
func enter() -> void :
	animation_player.play("attack_spin")

func process_input(event: InputEvent) -> State:
		return null

func process_physics(delta: float) -> State:
	if !animation_player.is_playing() :

		if parent.velocity.length() < 0.001 :
			return idleState
		else :
			return moveState
	parent.move_and_slide()
	return null

func _on_area_3d_body_entered(body: Node3D) -> void:
	if body is Enemy:
		var enemy : Enemy = body
		enemy.damaged(DMG)
