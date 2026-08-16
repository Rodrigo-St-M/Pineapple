extends Node
class_name WaveInfo
var type: Enemy.Types
var amount: int

func no_units_left() -> bool:
	return amount == 0
