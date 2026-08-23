extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	TransitionPlayer.play("drop_out_transition")
