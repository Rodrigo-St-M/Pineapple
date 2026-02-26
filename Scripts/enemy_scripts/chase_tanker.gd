extends State

@onready var crash: State = $"../Crash"
@onready var area_3d: Area3D = $"../../Area3D"

const SPEED : int = 10
#const DIRECTION_PERIOD : int = 20
const TURN_STRENGTH : float = 0.5
const MIN_VEL_TO_CRASH: int = 4
const ACCELERATION: float = 0.5


var current_speed: float
var direction: Vector3
var target : CharacterBody3D
var target_direction: Vector3

func enter() -> void :
	current_speed = 0
	area_3d.monitoring = false
	target = GameMaster.get_player()
	direction = (target.position - parent.position)
	


func process_physics(_delta: float) -> State:
	var state = null
	
	direction = parent.global_position.direction_to(target.position)
	direction.y = 0
	
	parent.basis = parent.basis.slerp(Basis.looking_at(direction), TURN_STRENGTH * _delta )
	#parent.direction_facing = direction
	current_speed = lerpf(current_speed, float(SPEED), ACCELERATION * _delta)
	if parent.get_real_velocity().length() > MIN_VEL_TO_CRASH:
		area_3d.monitoring = true
	
	parent.velocity = -parent.global_transform.basis.z * current_speed
	
	var collision : KinematicCollision3D = parent.move_and_collide(parent.velocity * _delta, true)
	if (collision != null && parent.velocity.normalized().dot(collision.get_normal()) < -0.87 
			&& parent.get_real_velocity().length() > MIN_VEL_TO_CRASH):
		parent.move_and_collide(parent.velocity * _delta)
		state = crash
	
	else:
		parent.move_and_slide()
	
	return state

func exit() -> void:
	area_3d.set_deferred("monitoring", false)

func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.get_instance_id() == target.get_instance_id():
		target.hurt(parent.velocity)
		parent.state_machine.change_state(crash)
