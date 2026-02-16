extends "res://Scripts/enemy_scripts/escape.gd"

var tower: Array

func enter() -> void:
	super()
	tower = parent.tower

func process_physics(_delta: float) -> State:
	parent.move_and_slide()
	for i in parent.get_slide_collision_count():
		var collider : Object = parent.get_slide_collision(i).get_collider()
		if collider && (pineapple_tree.position - parent.position).length() > MIN_ESCAPE_DISTANCE:
			emit_signal("pineapple_lost")
			GameMaster.lives_left -= 1
			tower[0].holding_pineapple.queue_free()
			return aproach_state
	return null
