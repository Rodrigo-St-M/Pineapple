extends HBoxContainer

const PINEAPPLE_DANGER = preload("uid://cxajdu7a5peqs")
const PINEAPPLE_LOST = preload("uid://ch2ajklhqjboi")
const PINEAPPLE_SAFE = preload("uid://b4q0jxhfgdfrs")

var lives_danger: int
var lives_lost: int

var pineapple_tree
var gm

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	lives_danger = 0
	lives_lost = 0
	gm = GameMaster.get_current_instance()
	pineapple_tree = gm.get_pineapple_tree()
	pineapple_tree.connect("pineapple_stolen", _on_pineapple_stolen)
	pineapple_tree.connect("pineapple_recovered", _on_pineapple_recover)
	gm.connect("life_lost", _on_life_lost)


func _on_pineapple_stolen() -> void:
	lives_danger += 1
	_update_lifes_hud()


func _on_pineapple_recover() -> void:
	lives_danger -= 1
	_update_lifes_hud()


func _on_life_lost() -> void:
	lives_danger -= 1
	lives_lost += 1
	_update_lifes_hud()


func _update_lifes_hud() -> void:
	var icons: Array = get_children()
	
	for i in icons.size():
		if i < GameMaster.get_lives_left() - lives_danger:
			icons[i].texture = PINEAPPLE_SAFE
		elif i < GameMaster.get_lives_left():
			icons[i].texture = PINEAPPLE_DANGER
		else:
			icons[i].texture = PINEAPPLE_LOST

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
	#pass
