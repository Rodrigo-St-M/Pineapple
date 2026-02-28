extends Enemy


@onready var state_machine: Node = $StateMachine
@onready var defeat: Node = $StateMachine/Defeat

@onready var stunned: State = $StateMachine/Stunned

var player : CharacterBody3D
var direction_facing: Vector3 = Vector3.ZERO
const SHIELD_MAX_ANGLE_RAD: float = PI / 2.0

func _init() -> void:
	type = Enemy.Types.TANK

func _ready() -> void:
	hitPoints = 1
	player = GameMaster.player
	add_to_group("enemies")
	state_machine.init(self)

func _physics_process(delta: float) -> void:
	state_machine.process_physics(delta)

func _process(delta: float) -> void:
	state_machine.process_frame(delta)

func _unhandled_input(event: InputEvent) -> void:
	state_machine.process_input(event)

func damaged(dmg: int, _direction: Vector3 = Vector3.ZERO) -> void:
	_direction = _direction - position
	
	if _direction.angle_to(-global_transform.basis.z) > SHIELD_MAX_ANGLE_RAD:
		hitPoints -= dmg
	if hitPoints <= 0:
		state_machine.change_state(defeat)
	
