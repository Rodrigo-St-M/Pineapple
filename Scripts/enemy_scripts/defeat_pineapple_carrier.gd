extends "res://Scripts/enemy_scripts/defeat.gd"

func enter() -> void:
	#print("stacker entered defeat")
	super()
	parent.collision_mask = 16
	parent.collision_layer = 0
	if parent.holding_pineapple != null:
		parent.remove_child(parent.holding_pineapple)
		parent.pineapple_tree.call("recover_pineapple", parent.holding_pineapple)
		parent.holding_pineapple = null
