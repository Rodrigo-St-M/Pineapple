extends Control

@onready var velocity_label: Label = $CanvasLayer/VelocityLabel
@onready var game_over_label: Label = $CanvasLayer/GameOverLabel

var player : CharacterBody3D
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player = get_node("../../Player")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	velocity_label.text = "Velocity: " + str("%0.2f" % player.velocity.length()," m/s") + str(player.velocity) + "\n"
	velocity_label.text += "Momentum: " + str("%0.2f" % PlayerState.speed_curve_in) + "\n"
	velocity_label.text += "State: " + player.get_state_name() 


func _on_node_3d_game_over() -> void:
	print("signal sent!")
	game_over_label.visible = true

func _on_restart_button_pressed() -> void:
	get_tree().reload_current_scene()
