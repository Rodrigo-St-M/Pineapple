extends State

var player : CharacterBody3D
# one second is 60 physics frames
const AIMING_END_FRAME : int = 180
const LOCK_END_FRAME : int = 15 + AIMING_END_FRAME
const LASER_END_FRAME : int = 20 + LOCK_END_FRAME
const AIM_PREDICTION : int = 25
const TURN_SPEED : float = 0.1
const HIDE_ENTER_DISTANCE : int = 5

var frame : int
var current_aim_position : Vector3

@onready var reload: State = $"../Reload"
@onready var hide: Node = $"../hide"

@onready var collision_shape_3d: CollisionShape3D = $LaserSight/CollisionShape3D
@onready var laser_sight: Area3D = $LaserSight

func enter() -> void:
	frame = 0
	player = parent.player
	
	collision_shape_3d.disabled = false
	current_aim_position = parent.player.position
	collision_shape_3d.shape.size.x = 0.1
	collision_shape_3d.shape.size.y = 0.1

func exit() -> void:
	laser_sight.monitoring = false
	collision_shape_3d.debug_color = Color("0099b36b")
	collision_shape_3d.disabled = true

func process_physics(_delta: float) -> State:
	if (parent.position - player.position).length() < HIDE_ENTER_DISTANCE:
		return hide
	frame += 1
	if frame <= AIMING_END_FRAME:
		# enemy is tracking player
		current_aim_position = lerp(current_aim_position,
				 parent.player.position + parent.player.get_last_motion() * AIM_PREDICTION,
				 TURN_SPEED)
		current_aim_position.y = parent.position.y
		parent.look_at(current_aim_position)
		return null
	
	if frame == LOCK_END_FRAME:
		collision_shape_3d.shape.size.x = 0.5
		collision_shape_3d.shape.size.y = 0.5
		return null
		
	if frame <= LOCK_END_FRAME:
		return null
	
	if frame <= LASER_END_FRAME:
		laser_sight.monitoring = true
		collision_shape_3d.debug_color = Color("b326006b")
		return null
	
	return reload


func _on_laser_sight_body_entered(body: Node3D) -> void:
	if body.get_instance_id() == parent.player.get_instance_id():
		parent.player.hurt(parent.position)
