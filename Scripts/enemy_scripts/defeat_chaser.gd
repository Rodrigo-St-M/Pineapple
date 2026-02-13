extends "res://Scripts/enemy_scripts/defeat.gd"


func process_physics(delta: float) -> State:
	super(delta)
	return null

func exit() -> void:
	super()
	parent.leave_array()
