extends Control

const N_OF_SCREENS = 4
var screen_n = 0

@onready var label: Label = $PanelContainer/MarginContainer/VBoxContainer2/HBoxContainer2/Label
@onready var texture_rect: TextureRect = $PanelContainer/MarginContainer/VBoxContainer2/HBoxContainer2/TextureRect


func _ready() -> void:
	TransitionPlayer.play("drop_out_transition")


func update_info() -> void:
	match screen_n:
		0:
			label.text = "An army of robots is trying to steal PACO's fresh pineapples! Only way to stop them is with some punches!

USE THE ARROW KEYS or LEFT JOYSTICK to move. Keep moving to build up momentum, indicated by the bar in the bottom left corner!

Paco can move real fast, but he takes a while to accelerate..."
			texture_rect.texture = preload("uid://x801xdipl78q")
		1:
			label.text = "The SUPER PINEAPPLE TREE starts with three pineapples as indicated on the top, but robots will come from all around and try to steal them!
			
			PRESS AND HOLD Z or RIGHT ACTION to perform a spin attack and send them flying!
			
			While you spin attack, you don't accelerate and turn slower... But you do bounce on walls!"
			texture_rect.texture = preload("uid://dxs5167jmbluw")
		2:
			label.text = "Some robots are just there to be in your way and slow you down. Don't let them pile up, beat them down!
			
			In a pinch, you can always PRESS SPACE or DOWN ACTION to jump and manouver above them!
			
			PACO is really strong, he won't go down as long as there is pineapples!"
			texture_rect.texture = preload("uid://dogjgnhnfhymq")
		_:
			label.text = "More and more types of robots join the battle. Gain new attacks for PACO to match their numbers!
			
			At the end of the level, you get to choose a new attack for PACO. Select it with the mouse.
			PRESS X or LEFT ACTION to preform your second attack!
			PRESS C or UP ACTION to perform your third attack!
			
			The faster you are, the stronger your attacks!"
			texture_rect.texture = preload("uid://boq5rjnthb5qu")


func _on_next_bttn_pressed() -> void:
	screen_n = (screen_n + 1) % N_OF_SCREENS
	update_info()


func _on_previous_bttn_pressed() -> void:
	screen_n = (screen_n - 1) % N_OF_SCREENS
	update_info()


func _on_main_menu_bttn_pressed() -> void:
	TransitionPlayer.play("drop_in_transition")
	var scene : PackedScene = load("res://scenes/main_menu.tscn")
	await TransitionPlayer.animation_finished
	get_tree().change_scene_to_node(scene.instantiate())
