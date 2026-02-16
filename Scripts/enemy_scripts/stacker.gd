extends Enemy

@onready var state_machine: Node = $StateMachine
@onready var defeat: State = $StateMachine/Defeat
@onready var stunned: State = $StateMachine/Stunned
@onready var follow_below: Node = $StateMachine/FollowBelow

var tower: Array
var tower_index: int

var player : CharacterBody3D
var pineapple_tree : StaticBody3D
var holding_pineapple : Node3D
var piece_below : Enemy

func _ready() -> void:
	#print(stacker_array_index)
	#tower = get_parent().array

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


func damaged(dmg: int) -> void:
	hitPoints -= dmg
	tower[tower_index] = null
	#tower[tower_index - 1].enter_state(Enemy.States.REORDER)
	#tower[tower_index - 1].piece_below = self.piece_below
	get_parent().attempt_destroy()
	if hitPoints <= 0:
		state_machine.change_state(defeat)
	else :
		state_machine.change_state(stunned)
