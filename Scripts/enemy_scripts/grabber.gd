extends Enemy

@onready var state_machine: Node = $StateMachine
@onready var defeat: Node = $StateMachine/Defeat
@onready var stunned: Node = $StateMachine/Stunned
var player : CharacterBody3D
var pineapple_tree : StaticBody3D
var holding_pineapple : Node3D

func _init() -> void:
	type = Enemy.Types.GRAB

func _ready() -> void:
	hitPoints = 1
	player = GameMaster.player
	pineapple_tree = GameMaster.pineapple_tree
	add_to_group("enemies")
	state_machine.init(self)
	
func _physics_process(delta: float) -> void:
	state_machine.process_physics(delta)

func _process(delta: float) -> void:
	state_machine.process_frame(delta)

func _unhandled_input(event: InputEvent) -> void:
	state_machine.process_input(event)

func damaged(dmg: int, _direction: Vector3 = Vector3.ZERO) -> void:
	hitPoints -= dmg
	if hitPoints <= 0:
		state_machine.change_state(defeat)
	else :
		state_machine.change_state(stunned)
