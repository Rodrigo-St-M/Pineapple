extends Control

@onready var label: Label = $CanvasLayer/Velocity_Label
var player : CharacterBody3D
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player = get_node("../../Player")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	label.text = "Velocity: " + str("%0.2f" % player.get_real_velocity().length()," m/s\n") 
	label.text += "State: " + player.get_state_name()
