extends State

var player: CharacterBody3D
const LEAVE_HIDE_DISTANCE : int = 7
@onready var aim_and_fire: Node = $"../AimAndFire"


func enter() -> void:
	player = parent.player

func process_physics(_delta: float) -> State:
	if (player.position - parent.position).length() < LEAVE_HIDE_DISTANCE:
		return null
	return aim_and_fire
