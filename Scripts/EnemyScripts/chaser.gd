extends Enemy
var player : CharacterBody3D
@onready var stateMachine: Node = $StateMachine
@onready var defeat: Node = $StateMachine/defeat
@onready var stunned: State = $StateMachine/stunned


func _ready() -> void:
	player = get_node("../Player")
	print(player)
	MAX_HP = 1
	hitPoints = 1
	stateMachine.init(self)
	add_to_group("enemies")

func _physics_process(delta: float) -> void:
	stateMachine.process_physics(delta)

func _process(delta: float) -> void:
	stateMachine.process_frame(delta)

func _unhandled_input(event: InputEvent) -> void:
	stateMachine.process_input(event)

func damaged(dmg: int) -> void:
	hitPoints -= dmg
	if hitPoints <= 0:
		stateMachine.change_state(defeat)
	else :
		stateMachine.change_state(stunned)
	
