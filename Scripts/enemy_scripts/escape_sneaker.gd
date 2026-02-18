extends "res://Scripts/enemy_scripts/escape.gd"

var player : CharacterBody3D

func enter() -> void:
	super()
	player = GameMaster.get_player()

func process_physics(_delta: float) -> State:
	direction = ((parent.position - pineapple_tree.position).normalized() * 1.1
			+ (parent.position - player.position).normalized())
	direction.y = 0
	parent.velocity = SPEED * direction.normalized()
	parent.move_and_slide()
	for i in parent.get_slide_collision_count():
		var collider : Object = parent.get_slide_collision(i).get_collider()
		if collider && (pineapple_tree.position - parent.position).length() > MIN_ESCAPE_DISTANCE:
			GameMaster.get_current_instance().pineapple_lost()
			parent.holding_pineapple.queue_free()
			return aproach_state
	return null
