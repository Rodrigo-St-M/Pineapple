class_name Enemy
extends CharacterBody3D
enum Types {
	CHASE,
	GRAB,
	STACK,
	FLAP,
	TANK,
	DIG,
	ROLL,
	LASER,
	SNEAK,
	BOMB
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

var enemyType
var hitPoints : int

func damaged(_dmg: int, _direction: Vector3 = Vector3.ZERO) -> void:
	pass
