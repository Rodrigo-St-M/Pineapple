extends Label


var score_manager

func _ready() -> void:
	score_manager = GameMaster.get_score_manager()

func _process(_delta: float) -> void:
	if score_manager.combo_score == 0:
		text = ""
	else:
		text = str(score_manager.combo_score)
