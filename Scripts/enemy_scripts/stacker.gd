extends Enemy

@onready var state_machine: Node = $StateMachine
@onready var defeat: State = $StateMachine/Defeat
@onready var stunned: State = $StateMachine/Stunned
@onready var follow_below: Node = $StateMachine/FollowBelow
@onready var reorder: Node = $StateMachine/Reorder
@onready var spawning: Node = $StateMachine/Spawning


@warning_ignore("unused_signal")
signal defeat_exit
signal destroy_tower

var tower: Array
var tower_index: int
var player : CharacterBody3D
var pineapple_tree : StaticBody3D
var holding_pineapple : Node3D
var piece_below : Enemy

func _init() -> void:
	type = Enemy.Types.STACK

func _ready() -> void:
	#print(stacker_array_index)
	#tower = get_parent().array
	tower_index = 0
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

func enter_state(state: Enemy.States) -> void:
	match state:
		Enemy.States.FOLLOW:
			state_machine.change_state(follow_below)
		Enemy.States.DEFEAT:
			state_machine.change_state(defeat)
		Enemy.States.REORDER:
			state_machine.change_state(reorder)


func damaged(dmg: int, _direction: Vector3 = Vector3.ZERO) -> void:
	hitPoints -= dmg

	if hitPoints <= 0 && get_current_state() != Enemy.States.DEFEAT:
		#get_parent().destroy()
		emit_signal("destroy_tower")
		state_machine.change_state(defeat)

func get_current_state() -> Enemy.States:
	match state_machine.current_state:
		follow_below:
			return Enemy.States.FOLLOW
		reorder:
			return Enemy.States.REORDER
		spawning:
			return Enemy.States.SPAWN
		defeat:
			return Enemy.States.DEFEAT
		_:
			return Enemy.States.ERROR
