extends TextureProgressBar

var combo_manager: Node
var combo_meter

const COMBO_C = preload("uid://na765lwpct1l")
const COMBO_B = preload("uid://d0ro0au4lmmpo")
const COMBO_A = preload("uid://cir5gc86pr13k")
const COMBO_S = preload("uid://covk251ph5i4")
const COMBO_P = preload("uid://dxgalwjbj2sor")

const C_COLOR = Color("d5a800ff")
const B_COLOR = Color("d55b00ff")
const A_COLOR = Color("f10021ff")
const S_COLOR = Color("c600f1ff")
const P_COLOR = Color("00cdf1ff")

func _ready() -> void:
	combo_manager = GameMaster.get_score_manager()
	combo_manager.connect("combo_over", _on_combo_done)
	combo_manager.connect("tier_up", _on_tier_up)

func _on_tier_up(tier: int) -> void:
	max_value = 50 + combo_manager.combo_tier * 50
	match tier:
		1:
			texture_under = COMBO_C
			texture_progress = COMBO_C
			tint_progress = C_COLOR
		2:
			texture_under = COMBO_B
			texture_progress = COMBO_B
			tint_progress = B_COLOR
		3:
			texture_under = COMBO_A
			texture_progress = COMBO_A
			tint_progress = A_COLOR
		4:
			texture_under =COMBO_S
			texture_progress = COMBO_S
			tint_progress = S_COLOR
		5:
			texture_under = COMBO_P
			texture_progress = COMBO_P
			tint_progress = P_COLOR
		_:
			pass

func _on_combo_done() -> void:
	texture_under = null
	texture_progress = null
	

func _process(_delta: float) -> void:
	combo_meter = combo_manager.combo_meter
	value = lerp(value, combo_meter, clampf( 5 * _delta, 0, 1))
