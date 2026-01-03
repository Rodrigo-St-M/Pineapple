extends Node3D

@onready var timer: Timer = $Timer
@export var chaserScene : PackedScene

var waveNumber : int = 0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var enemy_number : int = get_tree().get_node_count_in_group("enemies")
	if enemy_number == 0 && timer.is_stopped():
		timer.start()
		waveNumber += 1
func spawn_wave() -> void:
	print("wave " + str(waveNumber) + " spawned")
	var chaser = chaserScene.instantiate()
	add_child(chaser)


func _on_timer_timeout() -> void:
	spawn_wave()
