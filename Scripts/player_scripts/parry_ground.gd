extends PlayerState

@onready var animation_player: AnimationPlayer = $"../../../AnimationPlayer"
@onready var collision_shape_3d: CollisionShape3D = $"../../../AttackHitbox/CollisionShape3D"
@onready var attack_hitbox: Area3D = $"../../../AttackHitbox"
@onready var attack_mesh: MeshInstance3D = $"../../../AttackHitbox/AttackMesh"

@onready var idle : PlayerState = $"../../Idle"
@onready var fall : PlayerState = $"../../Fall"
@onready var move : PlayerState = $"../../Move"

const WEAK_RADIUS : float = 4
const MEDIUM_RADIUS : float = 6
const STRONG_RADIUS : float = 7

const PARRY_WINDOW_TIME : float = 1
const TRIGGER_TIME : float = 0.1
const EXPLOSION_TIME : float = 0.2 + TRIGGER_TIME
const COOLDOWN_TIME : float = 0.6 + EXPLOSION_TIME
const PARRY_DASH_DISTANCE : int = 25
const BRAKE_STRENGTH : float = 3 
const DMG : int = 3

var time : float
var parry_triggered : bool
var parry_time : float
var stored_velocity : float
var incoming_damage_direction : Vector3

func enter() -> void :
	animation_player.animation_finished.connect(_on_animation_player_animation_finished)
	attack_hitbox.body_entered.connect(_on_attack_hitbox_body_entered)
	parent.parried_attack.connect(_on_parry_succesfull)
	collision_shape_3d.shape = SphereShape3D.new()
	attack_mesh.mesh = SphereMesh.new()
	stored_velocity = parent.velocity.length()
	parent.parrying = true
	if speed_curve_in < NORMAL_SPEED_CURVE_IN_TRESHOLD:
		collision_shape_3d.shape.radius = WEAK_RADIUS
		attack_mesh.mesh.radius = WEAK_RADIUS
		attack_mesh.mesh.height = WEAK_RADIUS * 2
	elif speed_curve_in < STRONG_SPEED_CURVE_IN_TRESHOLD:
		collision_shape_3d.shape.radius = MEDIUM_RADIUS
		attack_mesh.mesh.radius = MEDIUM_RADIUS
		attack_mesh.mesh.height = MEDIUM_RADIUS * 2
	else:
		collision_shape_3d.shape.radius = STRONG_RADIUS
		attack_mesh.mesh.radius = STRONG_RADIUS
		attack_mesh.mesh.height = STRONG_RADIUS * 2
	
	time = 0
	parry_triggered = false


func process_input(_event: InputEvent) -> State:
	return null

func process_physics(_delta: float) -> State:
	var state : PlayerState = null
	
	parent.velocity = lerp(parent.velocity, Vector3.ZERO, BRAKE_STRENGTH * _delta)
	
	# if failed parry
	if time > PARRY_WINDOW_TIME && !parry_triggered:
		parent.parrying = false
		state = idle
	
	# is parry hit
	if parry_triggered:
		if time < parry_time + TRIGGER_TIME:
			parent.velocity = -incoming_damage_direction * PARRY_DASH_DISTANCE
		elif !attack_hitbox.monitoring && time < parry_time + EXPLOSION_TIME:
			parent.velocity = Vector3.ZERO
			attack_hitbox.monitoring = true
			attack_mesh.visible = true
		elif time > parry_time + EXPLOSION_TIME && attack_hitbox.monitoring:
			attack_hitbox.monitoring = false
			attack_mesh.visible = false
			parent.collision_mask = 20
			parent.collision_layer = 1
		elif time < parry_time + COOLDOWN_TIME:
			var v = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down").normalized()
			parent.velocity = lerp(parent.velocity, Vector3(v.x, 0.0, v.y) * stored_velocity, 10 * _delta)
		else:
			state =  move if parent.is_on_floor() else fall
	parent.move_and_slide()
	time += _delta
	return state


func _on_parry_succesfull(direction) -> void:
	parry_triggered = true
	parent.invincible_time = 0.3
	parry_time = time
	parent.collision_mask = 16
	parent.collision_layer = 0
	incoming_damage_direction = direction.normalized()
	
func exit() -> void:
	animation_player.stop()
	attack_mesh.visible = false
	attack_hitbox.monitoring = false
	parent.collision_mask = 20
	parent.collision_layer = 1
	animation_player.animation_finished.disconnect(_on_animation_player_animation_finished)
	attack_hitbox.body_entered.disconnect(_on_attack_hitbox_body_entered)
	parent.parried_attack.disconnect(_on_parry_succesfull)


func _on_attack_hitbox_body_entered(body: Node3D) -> void:
	if body is Enemy:
		var enemy : Enemy = body
		enemy.call("damaged", DMG, parent.position)


func _on_animation_player_animation_finished(_anim_name: StringName) -> void:
	pass
