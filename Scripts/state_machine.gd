extends Node

@export var starting_state : State

var current_state : State

## Initializes the state machine,
## A state machine is used whenever a node has many complex states, 
## separating each state into it's own script
## must be called on _ready() function of parent to work as intended
##
## parent The CharacterBody3D which this node is a child of
## requires starting_state != null
func init(parent : CharacterBody3D) -> void :
	for child in get_children() :
		child.parent = parent
	
	change_state(starting_state)

## Changes the current state that is being used to process physics and input
## to a new given state
##
## [new_state] the state to pass control over to
## requires this == new_state.get_parent()
func change_state(new_state : State) -> void :
	if current_state:
		current_state.exit()
	current_state = new_state
	current_state.enter()

## Used to pass control of parent's _physics_process() method to current_state
## Must be called inside of parent's _physics_process() to function
## [delta] delta from parent's _physics_process()
func process_physics(delta : float) -> void :
	var new_state = current_state.process_physics(delta)
	if new_state:
		change_state(new_state)

## Used to pass control of parent's _unhandled_input() method to current_state
## Must be called on parent's _unhandled_input() to function
## [event] InputEvent from parent's _unhandled_input()
func process_input(event : InputEvent) -> void :
	var new_state = current_state.process_input(event)
	if new_state:
		change_state(new_state)

## Used to pass control of parent's _process() method to current_state
## Must be called on parent's _process() to function
## [delta] delta from parent's _process()
func process_frame(delta : float) -> void :
	var new_state = current_state.process_frame(delta)
	if new_state:
		change_state(new_state)
