extends Control

@onready var progress_bar: TextureProgressBar = $CanvasLayer/MomentumBar
@onready var pineapple_tree: StaticBody3D = $"../../PineappleTree"
@onready var game_over_label: Label = $CanvasLayer/GameOverLabel

#const PINEAPPLE_DANGER = preload("uid://cxajdu7a5peqs")
#const PINEAPPLE_LOST = preload("uid://ch2ajklhqjboi")
#const PINEAPPLE_SAFE = preload("uid://b4q0jxhfgdfrs")


const NORMAL_SPEED_CURVE_IN_TRESHOLD : float = 0.45
const STRONG_SPEED_CURVE_IN_TRESHOLD : float = 1.2
const SUPER_FAST_CURVE_IN_TRESHOLD : float = 2.5
const SINE_AMPLITUDE : float = 0.005


const SLOW_COLOR = Color("00b83c")
const MEDIUM_COLOR = Color("d5b500")
const FAST_COLOR = Color("f16a00")

var sine_x: float = 0
var sine_variation: float = 0

func _process(_delta: float) -> void:
	# MOMENTUM BAR
	sine_variation = sin(sine_x) * SINE_AMPLITUDE
	sine_x += _delta * 7
	if PlayerState.speed_curve_in < NORMAL_SPEED_CURVE_IN_TRESHOLD:
		progress_bar.tint_progress = lerp(progress_bar.tint_progress, SLOW_COLOR, clampf( 5 * _delta, 0, 1))
	elif PlayerState.speed_curve_in < STRONG_SPEED_CURVE_IN_TRESHOLD:
		progress_bar.tint_progress = lerp(progress_bar.tint_progress, MEDIUM_COLOR, clampf( 5 * _delta, 0, 1))
	elif PlayerState.speed_curve_in < SUPER_FAST_CURVE_IN_TRESHOLD:
		progress_bar.tint_progress = lerp(progress_bar.tint_progress, FAST_COLOR, clampf( 5 * _delta, 0, 1))
	else:
		progress_bar.tint_progress.h += _delta / 3.0
	progress_bar.value = (sine_variation 
			+ lerpf(progress_bar.value, PlayerState.speed_curve_in, clampf( 5 * _delta, 0, 1)))
	#progress_bar.value = lerpf(progress_bar.value, SPEED_CURVE.sample(PlayerState.speed_curve_in), 0.3)

func _on_node_3d_game_over() -> void:
	game_over_label.visible = true

#func _on_pineapple_stolen() -> void:
	#lives_danger += 1
	#_update_lifes_hud()
#
#func _on_pineapple_recover() -> void:
	#lives_danger -= 1
	#_update_lifes_hud()
#
#func _on_life_lost() -> void:
	#lives_danger -= 1
	#lives_lost += 1
	#_update_lifes_hud()

#func _update_lifes_hud() -> void:
	#var icons: Array = lifes_indicator.get_children()
	#
	#for i in icons.size():
		#if i < GameMaster.get_lives_left() - lives_danger:
			#icons[i].texture = PINEAPPLE_SAFE
		#elif i < GameMaster.get_lives_left():
			#icons[i].texture = PINEAPPLE_DANGER
		#else:
			#icons[i].texture = PINEAPPLE_LOST

func _on_restart_button_pressed() -> void:
	get_tree().reload_current_scene()
