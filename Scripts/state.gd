class_name State
extends Node

var parent: CharacterBody3D

func enter() -> void:
	#TODO
	# if animation_name != null:
		# parent.animation.play(animation_name)
	pass

func exit() -> void:
	pass
	
func process_input(_event: InputEvent) -> State:
		return null

func process_frame(_delta: float) -> State:
		return null

func process_physics(_delta: float) -> State:
	return null
