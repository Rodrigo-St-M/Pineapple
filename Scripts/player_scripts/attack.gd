extends PlayerState
const TURN_STRENGHT : int = 22
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@export var idleState : State
@export var moveState : State

const DMG : int = 3
var just_collided : bool = false
func enter() -> void :
	animation_player.play("attack_spin")

func process_input(_event: InputEvent) -> State:
		return null

func process_physics(delta: float) -> State:
	if !animation_player.is_playing() :
		if parent.velocity.length() < 0.001 :
			return idleState
		else :
			return moveState
	var collision : KinematicCollision3D = parent.move_and_collide(parent.velocity * delta, true)
	if collision != null:
		parent.move_and_collide(parent.velocity * delta).get_remainder()
		parent.velocity = parent.velocity.bounce(collision.get_normal())
		parent.move_and_collide(collision.get_remainder())
	else :
		var input_dir = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down").normalized()
		input_dir = Vector3(input_dir.x, 0.0, input_dir.y)
		parse_movement_input(input_dir, delta,
				clamp(TURN_STRENGHT * delta *(1/parent.velocity.length()), 0, 1), true)
		parent.move_and_slide()
	return null

func _on_area_3d_body_entered(body: Node3D) -> void:
	if body is Enemy:
		var enemy : Enemy = body
		enemy.damaged(DMG)
