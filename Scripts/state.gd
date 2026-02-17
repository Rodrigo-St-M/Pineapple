class_name State
extends Node

## The CharacterBody3D this State is controling 
var parent: CharacterBody3D

## Array of arguments passed to this State before enter.
## If any State accepts arguments, they should be explained in the beginning of
## the State's script.
var enter_args: Array = []

func enter() -> void:
	pass

func exit() -> void:
	pass
	
func process_input(_event: InputEvent) -> State:
		return null

func process_frame(_delta: float) -> State:
		return null

func process_physics(_delta: float) -> State:
	return null
