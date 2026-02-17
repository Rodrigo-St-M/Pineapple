extends "res://Scripts/enemy_scripts/defeat_pineapple_carrier.gd"

func process_physics(delta: float) -> State:
	time += delta * FALL_SPEED
	direction.y = START_IMPACT_SPEED - time
	parent.velocity = direction
	
	parent.move_and_slide()
	
	if parent.is_on_floor() :
		#print(str(parent," is on floor, queueing free"))
		print("stacker_defeated")
		parent.queue_free()
		parent.defeat_exit.emit()
	return null
