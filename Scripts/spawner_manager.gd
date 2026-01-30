extends Node3D

@onready var timer: Timer = $Timer
@export var chaserScene : PackedScene

var waveNumber : int = 0
func _process(_delta: float) -> void:
	var enemy_number : int = get_tree().get_node_count_in_group("enemies")
	if enemy_number == 0 && timer.is_stopped():
		timer.start()
		waveNumber += 1


func spawn_wave() -> void:
	print("wave " + str(waveNumber) + " spawned")
	var chaser : Enemy= chaserScene.instantiate()
	add_child(chaser)
	chaser.position.y = 1


func _on_timer_timeout() -> void:
	spawn_wave()


class wave:
	var enemies : Enemy.enemyTypes
	var support : Enemy.enemyTypes
