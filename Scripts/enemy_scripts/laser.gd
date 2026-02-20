extends Enemy

@onready var state_machine: Node = $StateMachine
@onready var defeat: Node = $StateMachine/defeat
@onready var stunned: Node = $StateMachine/stunned

var player : CharacterBody3D

func _ready() -> void:
	hitPoints = 1
	player = GameMaster.player
	add_to_group("enemies")
	state_machine.init(self)
	
func _physics_process(delta: float) -> void:
	state_machine.process_physics(delta)

func _process(delta: float) -> void:
	state_machine.process_frame(delta)

func damaged(dmg: int, _direction: Vector3 = Vector3.ZERO) -> void:
	hitPoints -= dmg
	if hitPoints <= 0:
		state_machine.change_state(defeat)
	else :
		state_machine.change_state(stunned)
