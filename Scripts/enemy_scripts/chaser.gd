extends Enemy
#const CHASER : PackedScene = preload("uid://lhus61t1y3rb")

@onready var stateMachine: Node = $StateMachine
@onready var defeat_chaser: Node = $StateMachine/DefeatChaser
@onready var stunned: State = $StateMachine/stunned

var line_array : Array
var line_array_index : int

var player : CharacterBody3D
var next_chaser : Enemy
#static var num_in_seq : int = 0
#var chaser_line : Array[Enemy]
#var this_index : int = 0
# the chaser this chaser is following
# it's null if there is no chaser or it was defeated
#var next_chaser : Enemy

func _ready() -> void:
	safe_margin = 0.01

	hitPoints = 1
	player = GameMaster.player
	add_to_group("enemies")
	stateMachine.init(self)

#func pootis(this_chaser: Enemy, length: int) -> void:
#
	#if length == 0:
		#num_in_seq = 0
		#return
	#num_in_seq += 1
	#var new_chaser : Enemy = null
	#new_chaser = CHASER.instantiate()
	#new_chaser.chaser_line = chaser_line
	#new_chaser.this_index = num_in_seq
	#chaser_line.push_back(new_chaser)
	#
	#new_chaser.position = position
	#new_chaser.position.y += 5 * num_in_seq
	#add_sibling(new_chaser)
	#new_chaser.next_chaser = this_chaser
#
	#pootis(new_chaser, length -1)

func _physics_process(delta: float) -> void:
	stateMachine.process_physics(delta)

func _process(delta: float) -> void:
	stateMachine.process_frame(delta)

func _unhandled_input(event: InputEvent) -> void:
	stateMachine.process_input(event)

func damaged(dmg: int) -> void:
	hitPoints -= dmg
	if hitPoints <= 0:
		stateMachine.change_state(defeat_chaser)
	else :
		stateMachine.change_state(stunned)
	

func leave_array() -> void:
	line_array[line_array_index] = null
