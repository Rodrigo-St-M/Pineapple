extends Node
class_name GameMaster

static var score : int = 0
static var player : CharacterBody3D
static var pineapple_tree : StaticBody3D
static var pineapples : Array[Node3D]
static var is_game_over : bool = false
static var lives_left : int = 3
static var momentum : float

signal game_over

func _ready() -> void:
	is_game_over = false
	lives_left = 3
	
func _process(_delta: float) -> void:
	if is_game_over:
		return
	if lives_left == 0:
		emit_signal("game_over")
		is_game_over = true
