extends Camera3D

@onready var player: CharacterBody3D = %Player
const CAMERA_OFFSET : Vector3 = Vector3(0, 128, 128)
const CAM_LIMIT_UP : float = 106
const CAM_LIMIT_DOWN : float = 147
const CAM_LIMIT_SIDES : float = 20.5
const VELOCITY_PREDICTION : float = 2
const VELOCITY_INFLUENCE : float = 0.5
const SIZE_MIN : float = 9
const SIZE_MAX : float = 16
#in meters
var camera_width : float = size * (16.0 / 9.0)

func _physics_process(delta: float) -> void:
	size = lerp(size, clamp(SIZE_MIN + (player.velocity.length() * VELOCITY_INFLUENCE),
			SIZE_MIN, SIZE_MAX), 0.05)  
	camera_width = size * (16.0 / 9.0)
	
	position = lerp(position,
			player.position + player.velocity * VELOCITY_PREDICTION + CAMERA_OFFSET, 0.6 * delta)
	position.x = clamp(position.x, -CAM_LIMIT_SIDES + (camera_width / 2),
			 CAM_LIMIT_SIDES - (camera_width / 2))
	position.z = clamp(position.z, CAM_LIMIT_UP + (size / 2), CAM_LIMIT_DOWN - (size / 2))
