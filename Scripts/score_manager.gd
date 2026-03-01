extends Node

const METER_DEPLETE_RATE: int = 5

var total_score: int = 0
var combo_score: int = 0
var combo_meter: float = 0
var combo_tier: int = 0

signal tier_up(current_tier)
signal combo_over

var is_combo: bool
var gm: GameMaster

func _ready() -> void:
	is_combo = false
	GameMaster.score_manager = self
	GameMaster.get_player().player_bumped.connect(_on_mistake)
	gm = GameMaster.get_current_instance()
	gm.life_lost.connect(_on_mistake)
	gm.enemy_defeated.connect(_on_enemy_defeat)


func _process(_delta: float) -> void:
	if combo_meter > 0:
		combo_meter -= _delta * METER_DEPLETE_RATE * get_tier_mult(combo_tier)
	else:
		finish_combo()
	
	
	if combo_meter > 50 + combo_tier * 50:
		if combo_tier != 5:
			combo_tier += 1
			emit_signal("tier_up", combo_tier)
			combo_meter /= 2 
			print("tier up: ", combo_tier )
		else:
			combo_meter = 50 + combo_tier * 50


func finish_combo() -> void:
	emit_signal("combo_over")
	@warning_ignore("narrowing_conversion")
	total_score += combo_score * get_tier_deplete_mult(combo_tier)
	combo_score = 0
	combo_meter = 0
	combo_tier = 0
	is_combo = false


func get_tier_mult(tier: int) -> float:
	match tier:
		0:
			return 1
		1:
			return 1.33
		2:
			return 1.67
		3:
			return 2.0
		4:
			return 2.33
		5:
			return 3.0
		_:
			return 1

func get_tier_deplete_mult(tier: int) -> float:
	match tier:
		0:
			return 1
		1:
			return 1
		2:
			return 1.5
		3:
			return 2.0
		4:
			return 2.5
		5:
			return 3.0
		_:
			return 1

func get_type_points(type: Enemy.Types) -> int:
	match type:
		Enemy.Types.GRAB:
			return 25
		Enemy.Types.SNEAK:
			return 25
		Enemy.Types.STACK:
			return 30
		Enemy.Types.TANK:
			return 30
		Enemy.Types.CHASE:
			return 10
		Enemy.Types.LASER:
			return 25
		_:
			return 0

func _on_mistake() -> void:
	combo_score /= 2
	finish_combo()


func _on_enemy_defeat(type: Enemy.Types) -> void:
	var score_to_add = get_type_points(type)
	is_combo = true
	combo_score += score_to_add
	combo_meter += score_to_add
