class_name State
extends Node

# @export var animation_name: String

# input for speed curve. Must be preserved between states
var speed_curve_in : float = 0.0
var parent: CharacterBody3D

func enter() -> void:
	#TODO
	# if animation_name != null:
		# parent.animation.play(animation_name)
	pass

func exit() -> void:
	pass
	
func process_input(event: InputEvent) -> State:
		return null

func process_frame(delta: float) -> State:
		return null

func process_physics(delta: float) -> State:
	return null
