class_name Enemy
extends CharacterBody3D
enum enemyTypes {
	CHASE,
	GRAB,
	STACK,
	FLAP,
	TANK,
	DIG,
	ROLL,
	SNIPE,
	BOMB
	}

var enemyType
var hitPoints : int

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func damaged(_dmg: int) -> void:
	pass
