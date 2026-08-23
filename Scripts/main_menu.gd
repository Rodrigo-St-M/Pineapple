extends Control

func _ready() -> void:
	TransitionPlayer.play("RESET")
	await get_tree().create_timer(0.3).timeout
	TransitionPlayer.play("drop_out_transition")

func _on_new_game_bttn_pressed() -> void:
	TransitionPlayer.play("drop_in_transition")
	var scene : PackedScene = load("uid://bgwq4wa36ujqg")
	await TransitionPlayer.animation_finished
	get_tree().change_scene_to_node(scene.instantiate())

func _on_tutorial_bttn_pressed() -> void:
	TransitionPlayer.play("drop_in_transition")
	var scene : PackedScene = load("uid://b8ioh7ndhjbsy")
	await TransitionPlayer.animation_finished
	get_tree().change_scene_to_node(scene.instantiate())

func _on_credits_bttn_pressed() -> void:
	TransitionPlayer.play("drop_in_transition")
	var scene : PackedScene = load("uid://td7qwqmckwo")
	await TransitionPlayer.animation_finished
	get_tree().change_scene_to_node(scene.instantiate())

func _on_options_bttn_pressed() -> void:
	TransitionPlayer.play("drop_in_transition")
	var scene : PackedScene = load("uid://b56pv3ieiondu")
	await TransitionPlayer.animation_finished
	get_tree().change_scene_to_node(scene.instantiate())
