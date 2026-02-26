extends Node3D
const SPAWN_DISTANCE : float = 18.0
const WAVE_TIME_PERIOD : float = 30.0
const WAVE_ENEMY_DELAY : float = 1
const NUM_OF_PINEAPPLE_HOLDERS: int = 3

const GRABBER: PackedScene = preload("uid://b543gdht0q5vx")
const LASER: PackedScene = preload("uid://f42bx6kvbhhv")
const CHASER_LINE: PackedScene = preload("uid://70q68fc3subq")
const STACKER_TOWER: PackedScene = preload("uid://dh88cg3dt4fyx")
const SNEAKER: PackedScene = preload("uid://d0tw3uhj25li2")
const TANKER: PackedScene = preload("uid://dk8re0fmcdie2")
const WAVE_BUILDUP_RATE: float = 1 / 2.0
@onready var wave_timer: Timer = $WaveTimer
@onready var delay_timer: Timer = $DelayTimer
var spawn_queue : Array[Node3D]
var waveNumber : int = 1

func _process(_delta: float) -> void:
	var enemy_number : int = get_tree().get_node_count_in_group("enemies")
	if spawn_queue.size() == 0 && enemy_number == 0:
		spawn_wave()
		waveNumber += 1
		@warning_ignore("integer_division")
		delay_timer.wait_time = 1 + (3 / waveNumber)
		wave_timer.start(WAVE_TIME_PERIOD)

func spawn_wave() -> void:
	print("wave " + str(waveNumber) + " spawned")
	var wave = generate_wave_on_budjet()
	print(wave)
	while !wave.all(no_units_left):
		var i = get_valid_rand_index(wave)
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
		spawn_queue.push_back(enemy)
		wave[i].amount -= 1


func _on_wave_timer_timeout() -> void:
	spawn_wave()
	waveNumber += 1
	wave_timer.start(WAVE_TIME_PERIOD)


class EnemyWaveInfo:
	var type: Enemy.Types
	var amount: int
	
	
	func _to_string() -> String:
		return str(amount," ",type)

func no_units_left(enemy_wave_info) -> bool:
	return enemy_wave_info.amount <= 0


## Returns an almost random index of a given wave that still has units left
## wave the Array of EnemyWaveInfo to find an index
func get_valid_rand_index(wave: Array[EnemyWaveInfo]) -> int:
	var i: int = randi() % wave.size()
	var found: bool = false
	while !found:
		if wave[i].amount <= 0:
			i = (i + 1) % wave.size()
		else:
			found = true
	return i


func generate_wave_on_budjet() -> Array[EnemyWaveInfo]:
	var wave: Array[EnemyWaveInfo]
	var num_enemy_types: int
	
	var rand = randf()
	if waveNumber <= 3 || rand < 1.0/4.0:
		num_enemy_types = 2
		#wave of 2 types
	elif rand < 3.0/ 4.0:
		num_enemy_types = 3
		#wave of 3 types
	else:
		num_enemy_types = 4
		#wave of 4 types
	
	var enemy_types: Array = get_wave_types()
	wave.push_back(EnemyWaveInfo.new())
	wave[0].type = enemy_types.pop_at(randi_range(0, get_pineapple_holder_num() - 1))
	wave[0].amount = ceili(waveNumber * WAVE_BUILDUP_RATE * get_enemy_rate(wave[0].type) / num_enemy_types)
	
	for i in num_enemy_types - 1:
		wave.push_back(EnemyWaveInfo.new())
		wave[i+1].type = enemy_types.pop_at(randi_range(0, enemy_types.size() - 1))
		wave[i+1].amount = ceili(waveNumber * WAVE_BUILDUP_RATE * get_enemy_rate(wave[i+1].type) / num_enemy_types)
		
	
	return wave

## Returns the number of possible enemy types that are pineapple holders and can appear
## at the current wave Number
func get_pineapple_holder_num() -> int:
	if waveNumber <= 3:
		return 1
	elif waveNumber <= 8:
		return 2
	elif waveNumber <= 13:
		return 3
	elif waveNumber <= 18: #TODO
		return 3
	elif waveNumber <= 23: #TODO
		return 3
	else: #TODO
		return 3

## Returns an array with the possible enemy types you can encounter at the current
## waveNumber
func get_wave_types() -> Array[Enemy.Types]:
	if waveNumber <= 3:
		return [Enemy.Types.GRAB, Enemy.Types.CHASE]
	elif waveNumber <= 8:
		return [Enemy.Types.GRAB, Enemy.Types.STACK, Enemy.Types.CHASE, Enemy.Types.TANK]
	elif waveNumber <= 13:
		return [Enemy.Types.GRAB, Enemy.Types.STACK, Enemy.Types.SNEAK,
				 Enemy.Types.CHASE, Enemy.Types.TANK, Enemy.Types.LASER]
	elif waveNumber <= 18: #TODO
		return [Enemy.Types.GRAB, Enemy.Types.STACK, Enemy.Types.SNEAK,
				 Enemy.Types.CHASE, Enemy.Types.TANK, Enemy.Types.LASER]
	elif waveNumber <= 23: #TODO
		return [Enemy.Types.GRAB, Enemy.Types.STACK, Enemy.Types.SNEAK,
				 Enemy.Types.CHASE, Enemy.Types.TANK, Enemy.Types.LASER]
	else: #TODO
		return [Enemy.Types.GRAB, Enemy.Types.STACK, Enemy.Types.SNEAK,
				 Enemy.Types.CHASE, Enemy.Types.TANK, Enemy.Types.LASER]

## Returns a random float that represents how many enemies of a given type
## should spawn in comparison with other enemies, for example, for every STACK
## enemy, around 1.5 TANK enemies should spawn too. I
##
func get_enemy_rate(enemy: Enemy.Types) -> float:
	match enemy:
		Enemy.Types.GRAB:
			return absf(randfn(3.0, 0.33))
		Enemy.Types.STACK:
			return absf(randfn(2.0, 0.33))
		Enemy.Types.SNEAK:
			return absf(randfn(2.0, 0.33))
		Enemy.Types.CHASE:
			return absf(randfn(4.0, 0.33))
		Enemy.Types.TANK:
			return absf(randfn(2.0, 0.33))
		Enemy.Types.LASER:
			return absf(randfn(2.0, 0.33))
		_:
			return 0.0


func generate_wave() -> Array[Enemy.Types]:
	var wave : Array[Enemy.Types]
	
	
	@warning_ignore("integer_division")
	for i in range(1 + (waveNumber/2) ) :
		wave.push_back(Enemy.Types.CHASE)
	
	@warning_ignore("integer_division")
	for i in range(2 + (waveNumber / 3) ):
		wave.push_back(Enemy.Types.GRAB)
	
	@warning_ignore("integer_division")
	var num_laser = clamp( (waveNumber/4) - 2, 0, 64)
	for i in range(num_laser):
		wave.push_back(Enemy.Types.LASER)
	
	@warning_ignore("integer_division")
	var num_stacker = clamp( (waveNumber/3) - 1, 0, 64)
	for i in range(num_stacker):
		wave.push_back(Enemy.Types.STACK)
	
	@warning_ignore("integer_division")
	var num_sneaker = clamp( (waveNumber/4) - 1, 0, 64)
	for i in range(num_sneaker):
		wave.push_back(Enemy.Types.SNEAK)
	
	@warning_ignore("integer_division")
	var num_tanker = clamp( waveNumber/4, 0, 64)
	for i in range(num_tanker):
		wave.push_back(Enemy.Types.TANK)
	return wave


func _on_delay_timer_timeout() -> void:
	if !spawn_queue.is_empty() && get_tree().get_node_count_in_group("enemies") <= 32:
		add_child(spawn_queue.pop_front())
