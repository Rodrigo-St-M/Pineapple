extends State

var player : CharacterBody3D
# one second is 60 physics frames
const AIMING_DELAY : int = 180
const LASER_DURATION : int = 30
const AIM_PREDICTION : int = 25
const TURN_SPEED : float = 0.1
var frame : int
var current_aim_position : Vector3
@onready var reload: State = $"../Reload"

@onready var collision_shape_3d: CollisionShape3D = $LaserSight/CollisionShape3D
@onready var laser_sight: Area3D = $LaserSight

func enter() -> void:
	frame = 0
	collision_shape_3d.disabled = false
	current_aim_position = parent.player.position

func process_physics(_delta: float) -> State:
	frame += 1
	if frame <= AIMING_DELAY:
		current_aim_position = lerp(current_aim_position,
				 parent.player.position + parent.player.get_last_motion() * AIM_PREDICTION,
				 TURN_SPEED)
		current_aim_position.y = 0
		parent.look_at(current_aim_position)
		return null
	
	if frame <= AIMING_DELAY + LASER_DURATION:
		laser_sight.monitoring = true
		collision_shape_3d.debug_color = Color("b326006b")
		return null
	
	laser_sight.monitoring = false
	collision_shape_3d.debug_color = Color("0099b36b")
	collision_shape_3d.disabled = true
	
	return reload


func _on_laser_sight_body_entered(body: Node3D) -> void:
	if body.get_instance_id() == parent.player.get_instance_id():
		parent.player.hurt()
