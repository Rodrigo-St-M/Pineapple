extends Camera3D

@onready var player: CharacterBody3D = %Player
const CAMERA_OFFSET : Vector3 = Vector3(0, 16, 16)
const SIZE_MIN : float = 8
const SIZE_MAX : float = 32
#in meters
var camera_width : float = size * (9.0 / 16.0)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func _physics_process(delta: float) -> void:
	size = lerp(size, clamp(SIZE_MIN + (player.velocity.length() * 0.5), SIZE_MIN, SIZE_MAX), 0.05)  
	camera_width = size * (9.0 / 16.0)
	position = lerp(position, player.position + player.velocity * 2 + CAMERA_OFFSET, 0.6 * delta)
	position.x = clamp(position.x, -14 + (camera_width/2), 14 - (camera_width/2))
	position.z = clamp(position.z, -6 + (size/2), 36 - (size/2))
