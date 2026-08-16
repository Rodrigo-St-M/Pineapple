extends Node
class_name GameMaster
## This node is to be used as a signal bus,
## to process basic game logic like game state,
## and a way to pass refernces to important nodes 

## Game Logic Loop
## On scene start, game_master executes start level 
## on wave_timer.timeout or wave_manager.wave_defeated, enter level up menu
## after selecting option on menu, start level is called.

enum GameState {
	BRAWLING,
	UPGRADING,
	WAITING,
}
@onready var wave_timer: Timer = $"Spawner manager/WaveTimer"
@onready var spawner_manager: Node3D = $"Spawner manager"
@onready var transition_player: AnimationPlayer = $Camera3D/TransitionPlayer
@onready var level_complete_screen: Control = $Camera3D/LevelCompleteScreen

static var player : CharacterBody3D
static var pineapple_tree : StaticBody3D
static var pineapples : Array[Node3D]
static var is_game_over : bool = false
static var lives_left : int = 3
static var momentum : float
static var score_manager : Node
static var instance = null
static var game_state
static var level = 1



signal game_over
signal life_lost
signal enemy_defeated(type)

static func get_current_instance() -> GameMaster:
	return instance
	
func get_score_manager() -> Node:
	return score_manager

func get_lives_left() -> int:
	return lives_left

func get_pineapple_tree() -> StaticBody3D:
	return pineapple_tree

func get_player() -> CharacterBody3D:
	return player

func emit_enemy_defeated(type : Enemy.Types) -> void:
	enemy_defeated.emit(type)

func end_level() -> void:
	level += 1
	game_state = GameState.WAITING
	await get_tree().create_timer(3.0).timeout
	transition_player.play("drop_in_transition")
	await transition_player.animation_finished
	player.toggle_paused()
	level_complete_screen.set_powerup_options()
	level_complete_screen.visible = true
	transition_player.play("drop_out_transition")

func start_level() -> void:
	game_state = GameState.BRAWLING
	transition_player.play("drop_in_transition")
	await transition_player.animation_finished
	player.toggle_paused()
	spawner_manager.spawn_wave(level)
	level_complete_screen.visible = false
	wave_timer.start(100)
	transition_player.play("drop_out_transition")

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

func _ready() -> void:
	wave_timer.timeout.connect(end_level)
	player.toggle_paused()
	level_complete_screen.visible = false
	spawner_manager.spawn_wave(level)
	transition_player.play("drop_out_transition")
