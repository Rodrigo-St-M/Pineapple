extends Label


var score_manager

func _ready() -> void:
	score_manager = GameMaster.get_score_manager()

func _process(_delta: float) -> void:
	text = str("Score: ", "%09d" % score_manager.total_score)
