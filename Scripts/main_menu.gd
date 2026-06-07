extends Node2D

@onready var v_box_container: VBoxContainer = $CanvasLayer/VBoxContainer


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("jump"):
		get_tree().change_scene_to_file("res://scenes/arena.tscn")
		
	elif event.is_action_pressed("attack0"):
		v_box_container.visible = true
	elif event.is_action_released("attack0"):
		v_box_container.visible = false
