extends "res://Scripts/enemy_scripts/defeat.gd"



func enter() -> void:
	if parent.holding_pineapple != null:
		parent.remove_child(parent.holding_pineapple)
		parent.pineapple_tree.call("recover_pineapple", parent.holding_pineapple)
		parent.holding_pineapple = null
	time = 0
	direction = - (parent.player.position - parent.position).normalized()
	direction *= (START_IMPACT_SPEED 
			+ direction.dot(parent.player.velocity.normalized()) * parent.player.velocity.length())
	parent.collision_layer = 0
