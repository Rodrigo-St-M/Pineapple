extends Node
class_name WaveGenerator
const WAVE_BUILDUP_RATE: float = 1 / 2.0

static func generate_wave_on_budjet(level : int) -> Array[WaveInfo]:
	var wave: Array[WaveInfo]
	var num_enemy_types: int
	
	var rand = randf()
	if level <= 3 || rand < 1.0/4.0:
		num_enemy_types = 2
		#wave of 2 types
	elif rand < 3.0/ 4.0:
		num_enemy_types = 3
		#wave of 3 types
	else:
		num_enemy_types = 4
		#wave of 4 types
	
	var enemy_types: Array = get_wave_types(level)
	wave.push_back(WaveInfo.new())
	wave[0].type = enemy_types.pop_at(randi_range(0, get_pineapple_holder_num(level) - 1))
	wave[0].amount = ceili(level * WAVE_BUILDUP_RATE * get_enemy_rate(wave[0].type) / num_enemy_types)
	
	for i in num_enemy_types - 1:
		wave.push_back(WaveInfo.new())
		wave[i+1].type = enemy_types.pop_at(randi_range(0, enemy_types.size() - 1))
		wave[i+1].amount = ceili(level * WAVE_BUILDUP_RATE * get_enemy_rate(wave[i+1].type) / num_enemy_types)
		
	
	return wave

## Returns the number of possible enemy types that are pineapple holders and can appear
## at the current wave Number
static func get_pineapple_holder_num(level : int) -> int:
	if level <= 1:
		return 1
	elif level <= 2:
		return 2
	elif level <= 3:
		return 3
	elif level <= 4: #TODO
		return 3
	elif level <= 5: #TODO
		return 3
	else: #TODO
		return 3

## Returns an array with the possible enemy types you can encounter at the current
## level
static func get_wave_types(level : int) -> Array[Enemy.Types]:
	if level <= 1:
		return [Enemy.Types.GRAB, Enemy.Types.CHASE]
	elif level <= 2:
		return [Enemy.Types.GRAB, Enemy.Types.STACK, Enemy.Types.CHASE, Enemy.Types.TANK]
	elif level <= 3:
		return [Enemy.Types.GRAB, Enemy.Types.STACK, Enemy.Types.SNEAK,
				 Enemy.Types.CHASE, Enemy.Types.TANK, Enemy.Types.LASER]
	elif level <= 4: #TODO
		return [Enemy.Types.GRAB, Enemy.Types.STACK, Enemy.Types.SNEAK,
				 Enemy.Types.CHASE, Enemy.Types.TANK, Enemy.Types.LASER]
	elif level <= 5: #TODO
		return [Enemy.Types.GRAB, Enemy.Types.STACK, Enemy.Types.SNEAK,
				 Enemy.Types.CHASE, Enemy.Types.TANK, Enemy.Types.LASER]
	else: #TODO
		return [Enemy.Types.GRAB, Enemy.Types.STACK, Enemy.Types.SNEAK,
				 Enemy.Types.CHASE, Enemy.Types.TANK, Enemy.Types.LASER]

## Returns a random float that represents how many enemies of a given type
## should spawn in comparison with other enemies, for example, for every STACK
## enemy, around 1.5 TANK enemies should spawn too.
##
static func get_enemy_rate(enemy: Enemy.Types) -> float:
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
