extends Camera3D

@onready var player: CharacterBody3D = %Player
const CAMERA_OFFSET : Vector3 = Vector3(0, 7, 7)
const SIZE_MIN : float = 8
const SIZE_MAX : float = 12
#in meters
var CAMERA_WIDTH : float = size * (9.0 / 16.0)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func _physics_process(delta: float) -> void:
	size = lerp(size, clamp(SIZE_MIN + (player.velocity.length() * 0.1), SIZE_MIN, SIZE_MAX), 0.2)  
	CAMERA_WIDTH = size * (9.0 / 16.0)
	position = lerp(position, player.position + player.velocity * 2 + CAMERA_OFFSET, 0.6 * delta)
	position.x = clamp(position.x, -14 + (CAMERA_WIDTH/2), 14 - (CAMERA_WIDTH/2))
	position.z = clamp(position.z, -14 + (size/2), 26 - (size/2))
