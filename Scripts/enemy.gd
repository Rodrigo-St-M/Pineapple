class_name Enemy
extends CharacterBody3D
enum Types {
	GRAB,
	SNEAK,
	STACK,
	CHASE,
	TANK,
	LASER
	}
	
enum States {
	ERROR = -1,
	APROACH,
	DEFEAT,
	ESCAPE,
	SPAWN,
	FOLLOW,
	REORDER,
	STUNNED,
	WAIT,
	}

var type: Enemy.Types
var hitPoints : int

func damaged(_dmg: int, _direction: Vector3 = Vector3.ZERO) -> void:
	pass
