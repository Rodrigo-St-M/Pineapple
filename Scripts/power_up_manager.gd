extends StaticBody3D


var gm : GameMaster
var locked_powerups : Array[PlayerState.Attacks] = [
		PlayerState.Attacks.CLAP,
		PlayerState.Attacks.DASH,
		PlayerState.Attacks.PARRY,
		PlayerState.Attacks.PUNCH ]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	gm = GameMaster.get_current_instance()
	

func get_powerup_options() -> Array[PlayerState.Attacks]:
	var options : Array[PlayerState.Attacks]
	for powerup in locked_powerups:
		options.append(powerup)
	options.shuffle()
	options.resize(3)
	return options

func select_powerup(selected : PlayerState.Attacks) -> bool:
	if locked_powerups.has(selected):
		locked_powerups.erase(selected)
		return true
	return false
