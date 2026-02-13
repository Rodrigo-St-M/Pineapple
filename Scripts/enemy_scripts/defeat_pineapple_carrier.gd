extends "res://Scripts/enemy_scripts/defeat.gd"



func enter() -> void:
	if parent.holding_pineapple != null:
		parent.remove_child(parent.holding_pineapple)
		parent.pineapple_tree.call("recover_pineapple", parent.holding_pineapple)
		parent.holding_pineapple = null
	super()
