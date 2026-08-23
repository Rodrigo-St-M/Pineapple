extends Button

func _on_pressed() -> void:
	TransitionPlayer.play("drop_in_transition")
	var scene :PackedScene = load("uid://dr78rj16umshh")
	
	await TransitionPlayer.animation_finished
	get_tree().change_scene_to_node(scene.instantiate())
