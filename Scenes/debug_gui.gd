extends Control

@onready var velocity_label: Label = $CanvasLayer/Velocity_Label
var player : CharacterBody3D
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player = get_node("../../Player")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	velocity_label.text = "Velocity: " + str("%0.2f" % player.get_real_velocity().length()," m/s") 
