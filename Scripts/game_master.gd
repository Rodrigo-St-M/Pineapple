extends Node
class_name GameMaster
## This node is to be used as a signal bus,
## to process basic game logic,
## and a way to pass refernces to important nodes 


static var player : CharacterBody3D
static var pineapple_tree : StaticBody3D
static var pineapples : Array[Node3D]
static var is_game_over : bool = false
static var lives_left : int = 3
static var momentum : float
static var score_manager : Node
static var instance = null

signal game_over
signal life_lost

signal enemy_defeated(type)

static func get_score_manager() -> Node:
	return score_manager

static func get_current_instance() -> GameMaster:
	return instance

static func get_lives_left() -> int:
	return lives_left

static func get_pineapple_tree() -> StaticBody3D:
	return pineapple_tree

static func get_player() -> CharacterBody3D:
	return player

func emit_enemy_defeated(type : Enemy.Types) -> void:
	enemy_defeated.emit(type)

func pineapple_lost() -> void:
	lives_left -= 1
	life_lost.emit()
	if lives_left == 0:
		game_over.emit()
		Engine.time_scale = 0.0
		is_game_over = true

func _enter_tree() -> void:
	Engine.time_scale = 1.0
	instance = self
	is_game_over = false
	lives_left = 3
