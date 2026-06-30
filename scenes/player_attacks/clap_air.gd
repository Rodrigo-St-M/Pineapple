extends PlayerState

@onready var animation_player: AnimationPlayer = $"../../../AnimationPlayer"
@onready var collision_shape_3d: CollisionShape3D = $"../../../AttackHitbox/CollisionShape3D"
@onready var attack_hitbox: Area3D = $"../../../AttackHitbox"
@onready var attack_mesh: MeshInstance3D = $"../../../AttackHitbox/AttackMesh"
@onready var fall: PlayerState = $"../../Fall"
@onready var move: PlayerState = $"../../Move"

const DMG: int = 3

const START_TIME: float = 0.1
const HIT_TIME: float = START_TIME + 0.1
const RECOIL_TIME: float = HIT_TIME + 0.3
const WEAK_RADIUS : float = 2
const MEDIUM_RADIUS : float = 2.25
const STRONG_RADIUS : float = 2.75

var stored_h_velocity : Vector3
var stored_v_velocity : float
var is_clap_flipping : bool
var time : float

func enter() -> void:
	animation_player.animation_finished.connect(_on_animation_player_animation_finished)
	attack_hitbox.body_entered.connect(_on_attack_hitbox_body_entered)
	is_clap_flipping = true
	time = 0
	var v = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down").normalized()
	var horiz_velocity = Vector3(parent.velocity.x, 0.0, parent.velocity.y).length()
	stored_h_velocity = Vector3(v.x, 0.0, v.y) * horiz_velocity
	stored_v_velocity = parent.velocity.y
	
	# setting up hit box
	collision_shape_3d.shape = SphereShape3D.new()
	attack_mesh.mesh = SphereMesh.new()
	
	if speed_curve_in < NORMAL_SPEED_CURVE_IN_TRESHOLD:
		collision_shape_3d.shape.radius = WEAK_RADIUS
		attack_mesh.mesh.radius = WEAK_RADIUS
		attack_mesh.mesh.height = 2 * WEAK_RADIUS
		attack_hitbox.position = stored_h_velocity.normalized() * WEAK_RADIUS
	elif speed_curve_in < NORMAL_SPEED_CURVE_IN_TRESHOLD:
		collision_shape_3d.shape.radius = MEDIUM_RADIUS
		attack_mesh.mesh.radius = MEDIUM_RADIUS
		attack_mesh.mesh.height = 2 * MEDIUM_RADIUS
		attack_hitbox.position = stored_h_velocity.normalized() * MEDIUM_RADIUS
	else:
		collision_shape_3d.shape.radius = STRONG_RADIUS
		attack_mesh.mesh.radius = STRONG_RADIUS
		attack_mesh.mesh.height = 2 * STRONG_RADIUS
		attack_hitbox.position = stored_h_velocity.normalized() * STRONG_RADIUS
	##  collision_shape_3d.ro tation.y = -stored_h_velocity.angle_to(Vector3(1,0,0))
	## collision_shape_3d.rotation.z = deg_to_rad(90)
	animation_player.play("clap_start") 

func process_physics(_delta: float) -> State:
	var state = null
	if time < START_TIME:
		parent.velocity.y -= (_delta * parent.get_gravity().length() * 4)
		parent.move_and_slide()
	elif time < HIT_TIME:
		if !attack_hitbox.monitoring :
			attack_hitbox.monitoring = true
			attack_mesh.visible = true
		parent.velocity = Vector3.ZERO
	elif time < RECOIL_TIME:
		if is_clap_flipping :
			attack_hitbox.monitoring = false
			attack_mesh.visible = false
			is_clap_flipping = !is_clap_flipping
			parent.velocity = -stored_h_velocity
			parent.velocity.y = stored_v_velocity
		parent.velocity.y -= (_delta * parent.get_gravity().length() * 4)
		parent.move_and_slide()
	else:
		if parent.is_on_floor():
			state = move
		else:
			state = fall
		parent.move_and_slide() 
	time += _delta
	return state


func _on_animation_player_animation_finished(_anim_name: StringName) -> void:
	pass
	

func flip_velocity() -> void:
	parent.velocity = -stored_h_velocity

func _on_attack_hitbox_body_entered(_body: Node3D) -> void:
	if _body is Enemy:
		var enemy : Enemy = _body
		enemy.call("damaged", DMG, parent.position)


func exit() -> void:
	attack_hitbox.position = Vector3.ZERO
	attack_hitbox.body_entered.disconnect(_on_attack_hitbox_body_entered)
	animation_player.animation_finished.disconnect(_on_animation_player_animation_finished)
