extends Node
class_name GameMaster

static var score : int = 0
static var player : CharacterBody3D
static var pineapple_tree : StaticBody3D
static var pineapples : Array[Node3D]
static var is_game_over : bool = false
static var lives_left : int = 3
static var momentum : float
static var instance = null

signal game_over
signal life_lost

static func get_current_instance() -> GameMaster:
	return instance

static func get_lives_left() -> int:
	return lives_left

static func get_pineapple_tree() -> StaticBody3D:
	return pineapple_tree

static func get_player() -> CharacterBody3D:
	return player

func pineapple_lost() -> void:
	lives_left -= 1
	life_lost.emit()
	if lives_left == 0:
		game_over.emit()
		is_game_over = true

func _enter_tree() -> void:
	instance = self
	is_game_over = false
	lives_left = 3
