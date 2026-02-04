extends Node3D
const SPAWN_DISTANCE : float = 18.0
const WAVE_TIME_PERIOD : float = 30.0
@onready var timer: Timer = $Timer
@export var chaser_scene : PackedScene
@export var grabber_scene : PackedScene
var random : RandomNumberGenerator = RandomNumberGenerator.new()

var waveNumber : int = 0
	
func _process(_delta: float) -> void:
	var enemy_number : int = get_tree().get_node_count_in_group("enemies")
	if enemy_number == 0:
		spawn_wave()
		waveNumber += 1
		timer.start(WAVE_TIME_PERIOD)


func spawn_wave() -> void:
	print("wave " + str(waveNumber) + " spawned")
	var wave_details = generate_wave_details()
	while !wave_details.is_empty():
		var i = random.randi_range(0, wave_details.size() -1)
		var enemy : Enemy
		match wave_details[i]:
			Enemy.enemyTypes.CHASE:
				enemy = chaser_scene.instantiate()
			Enemy.enemyTypes.GRAB:
				enemy = grabber_scene.instantiate()
		enemy.position.x = randf_range(-1, 1)
		enemy.position.z = randf_range(-1, 1)
		enemy.position = enemy.position.normalized() * SPAWN_DISTANCE 
		enemy.position.y = 1
		add_child(enemy)
		wave_details.pop_at(i)


func _on_timer_timeout() -> void:
	spawn_wave()
	waveNumber += 1
	timer.start(WAVE_TIME_PERIOD)

func generate_wave_details() -> Array[Enemy.enemyTypes]:
	var wave : Array[Enemy.enemyTypes]
	for i in range(3 * waveNumber):
		wave.push_back(Enemy.enemyTypes.CHASE)
	for i in range(5 * waveNumber):
		wave.push_back(Enemy.enemyTypes.GRAB)
	return wave
