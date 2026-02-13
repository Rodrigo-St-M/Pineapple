extends Node3D
const SPAWN_DISTANCE : float = 18.0
const WAVE_TIME_PERIOD : float = 30.0
const WAVE_ENEMY_DELAY : float = 1
var spawn_queue : Array[Node3D]
@onready var wave_timer: Timer = $WaveTimer
@onready var delay_timer: Timer = $DelayTimer

const CHASER : PackedScene = preload("uid://lhus61t1y3rb")
const GRABBER : PackedScene = preload("uid://b543gdht0q5vx")
const LASER : PackedScene = preload("uid://f42bx6kvbhhv")
const CHASER_LINE : PackedScene = preload("uid://70q68fc3subq")


var random : RandomNumberGenerator = RandomNumberGenerator.new()

var waveNumber : int = 1
	
func _process(_delta: float) -> void:
	var enemy_number : int = get_tree().get_node_count_in_group("enemies")
	if spawn_queue.size() == 0 && enemy_number == 0:
		spawn_wave()
		waveNumber += 1
		wave_timer.start(WAVE_TIME_PERIOD)


func spawn_wave() -> void:
	print("wave " + str(waveNumber) + " spawned")
	var wave_details = generate_wave_details()
	while !wave_details.is_empty():
		var i = random.randi_range(0, wave_details.size() -1)
		var enemy : Node3D
		match wave_details[i]:
			Enemy.enemyTypes.CHASE:
				enemy = CHASER_LINE.instantiate()
			Enemy.enemyTypes.GRAB:
				enemy = GRABBER.instantiate()
			Enemy.enemyTypes.LASER:
				enemy = LASER.instantiate()
				
		enemy.position.x = randf_range(-1, 1)
		enemy.position.z = randf_range(-1, 1)
		enemy.position = enemy.position.normalized() * SPAWN_DISTANCE 
		enemy.position.y = 10
		spawn_queue.push_back(enemy)
		wave_details.pop_at(i)


func _on_wave_timer_timeout() -> void:
	spawn_wave()
	waveNumber += 1
	wave_timer.start(WAVE_TIME_PERIOD)

func generate_wave_details() -> Array[Enemy.enemyTypes]:
	var wave : Array[Enemy.enemyTypes]
	for i in range(1 + (1 * waveNumber / 2) ) :
		wave.push_back(Enemy.enemyTypes.CHASE)
	for i in range(2 * waveNumber - 1):
		wave.push_back(Enemy.enemyTypes.GRAB)
	@warning_ignore("integer_division")
	var num_laser = clamp(waveNumber - 2, 0, 64)
	for i in range(num_laser):
		wave.push_back(Enemy.enemyTypes.LASER)
	return wave


func _on_delay_timer_timeout() -> void:
	if !spawn_queue.is_empty():
		add_child(spawn_queue.pop_front())
