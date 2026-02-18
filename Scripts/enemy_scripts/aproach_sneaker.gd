extends "res://Scripts/enemy_scripts/aproach.gd"

var player : CharacterBody3D

func enter() -> void :
	super()
	player = GameMaster.get_player()

func process_physics(_delta: float) -> State:
	direction = ((pineapple_tree.position - parent.position).normalized() * 1.1
			+ (parent.position - player.position).normalized())
	direction.y = 0.0
	parent.velocity = SPEED * direction.normalized()
	
	parent.move_and_slide()
	for i in parent.get_slide_collision_count():
		var collider : Object = parent.get_slide_collision(i).get_collider()
		if collider.get_instance_id() == pineapple_tree.get_instance_id():
			parent.holding_pineapple = pineapple_tree.call("steal_pineapple")
		if parent.holding_pineapple:
			parent.add_child( parent.holding_pineapple )
			return escape_state
	
	return null
