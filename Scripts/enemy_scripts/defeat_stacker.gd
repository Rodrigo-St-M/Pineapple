extends "res://Scripts/enemy_scripts/defeat_pineapple_carrier.gd"

var tower: Array
var index: int

func exit() -> void:
	super()
	parent.get_parent().queue_free()
