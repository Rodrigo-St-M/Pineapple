extends "res://Scripts/enemy_scripts/defeat.gd"


func enter() -> void:
	super()
	parent.leave_array()

func process_physics(delta: float) -> State:
	super(delta)
	return null
