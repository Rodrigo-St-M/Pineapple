extends Enemy

@onready var state_machine: Node = $StateMachine
@onready var reorder: Node = $StateMachine/Reorder
@onready var defeat: Node = $StateMachine/Defeat
@onready var stunned: Node = $StateMachine/Stunned
@onready var spawning: Node = $StateMachine/Spawning
@onready var follow_below: Node = $StateMachine/FollowBelow
@onready var escape_stacker: Node = $StateMachine/Escape
@onready var aproach_stacker: Node = $StateMachine/Aproach

signal destroy_tower(index: int)

var player : CharacterBody3D
var pineapple_tree : StaticBody3D
var tower: Array
var tower_index: int
var piece_below: Enemy
var piece_above: Enemy

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


func enter_state(state: Enemy.States) -> void:
	match state:
		Enemy.States.REORDER:
			state_machine.change_state(reorder)
		Enemy.States.FOLLOW:
			state_machine.change_state(follow_below)
		Enemy.States.SPAWN:
			state_machine.change_state(spawning)
		Enemy.States.DEFEAT:
			state_machine.change_state(defeat)
		Enemy.States.ESCAPE:
			state_machine.change_state(escape_stacker)
		Enemy.States.APROACH:
			state_machine.change_state(aproach_stacker)


func damaged(dmg: int) -> void:
	hitPoints -= dmg
	
	if hitPoints <= 0 && get_current_state() != Enemy.States.DEFEAT:
		#tower[tower_index] = null
		if piece_above.get_current_state() != Enemy.States.DEFEAT:
			piece_above.enter_state(Enemy.States.REORDER)
		state_machine.change_state(defeat)
		if piece_above == tower[0]:
			emit_signal("destroy_tower")
		piece_above.piece_below = self.piece_below
		if piece_below:
			piece_below.piece_above = self.piece_above

func get_current_state() -> Enemy.States:
	match state_machine.current_state:
		reorder:
			return Enemy.States.REORDER
		spawning:
			return Enemy.States.SPAWN
		defeat:
			return Enemy.States.DEFEAT
		follow_below:
			return Enemy.States.FOLLOW
		_:
			if tower[0] && tower[0].holding_pineapple:
				return Enemy.States.ESCAPE
			else:
				return Enemy.States.APROACH
