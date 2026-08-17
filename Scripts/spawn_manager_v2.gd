extends Node

const SPAWN_DISTANCE : float = 18.0
const WAVE_TIME_PERIOD : float = 30.0
const WAVE_ENEMY_DELAY : float = 2.0
const WAVE_ENEMY_DELAY_SPEEDUP : float = 0.20
const NUM_OF_PINEAPPLE_HOLDERS: int = 3

const GRABBER: PackedScene = preload("uid://b543gdht0q5vx")
const LASER: PackedScene = preload("uid://f42bx6kvbhhv")
const CHASER_LINE: PackedScene = preload("uid://70q68fc3subq")
const STACKER_TOWER: PackedScene = preload("uid://dh88cg3dt4fyx")
const SNEAKER: PackedScene = preload("uid://d0tw3uhj25li2")
const TANKER: PackedScene = preload("uid://dk8re0fmcdie2")

signal wave_finished

@onready var wave_timer: Timer = $WaveTimer
@onready var delay_timer: Timer = $DelayTimer

var waveNumber : int = 1
var wave
var enemies_alive : int
var enemies_to_spawn : int

func _on_enemy_defeated(_type) -> void:
	enemies_alive -= 1
	if enemies_alive == 0:
		finish_wave()

func spawn_wave(level : int) -> void:
	wave = WaveGenerator.generate_wave_on_budjet(level)
	enemies_alive = get_wave_total_enemies()
	enemies_to_spawn = get_wave_total_spawns()
	delay_timer.start(WAVE_ENEMY_DELAY - (WAVE_ENEMY_DELAY_SPEEDUP * (level - 1)))
	wave_timer.start(100)


func finish_wave() -> void:
	delay_timer.stop()
	wave_timer.stop()
	get_tree().call_group("enemies", "damaged", 99)
	wave_finished.emit()

func _on_delay_timer_timeout() -> void:
	#print("here goes")
	var i = get_valid_rand_index()
	var enemy : Node3D
	match wave[i].type:
		Enemy.Types.CHASE:
			enemy = CHASER_LINE.instantiate()
		Enemy.Types.GRAB:
			enemy = GRABBER.instantiate()
		Enemy.Types.LASER:
			enemy = LASER.instantiate()
		Enemy.Types.STACK:
			enemy = STACKER_TOWER.instantiate()
		Enemy.Types.SNEAK:
			enemy = SNEAKER.instantiate()
		Enemy.Types.TANK:
			enemy = TANKER.instantiate()
	
	enemy.position.x = randf_range(-1, 1)
	enemy.position.z = randf_range(-1, 1)
	enemy.position = enemy.position.normalized() * SPAWN_DISTANCE 
	enemy.position.y = 10
	wave[i].amount -= 1
	enemies_to_spawn -= 1
	add_child(enemy)
	#print("spawned" + str(enemy))
	#print(str(enemies_to_spawn) + "left in wave")
	if enemies_to_spawn > 0:
		delay_timer.start()

## Returns an almost random index of a given wave that still has units left
## wave the Array of EnemyWaveInfo to find an index
func get_valid_rand_index() -> int:
	var i: int = randi() % wave.size()
	var found: bool = false
	while !found:
		if wave[i].amount <= 0:
			i = (i + 1) % wave.size()
		else:
			found = true
	return i


func get_wave_total_enemies() -> int:
	var acc: int = 0
	for info: WaveInfo in wave:
		if (info.type == Enemy.Types.CHASE) || (info.type == Enemy.Types.STACK) :
			acc += info.amount * 5
		else:
			acc += info.amount
	return acc
	
func get_wave_total_spawns() -> int:
	var acc: int = 0
	for info: WaveInfo in wave:
		acc += info.amount
	return acc
