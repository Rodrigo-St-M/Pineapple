extends State

const RELOAD_DELAY_MIN : int = 180
const RELOAD_DELAY_MAX : int = 360

@onready var aim_and_fire: Node = $"../AimAndFire"
var frame : int 
var reload_time : int


func enter() -> void:
	frame = 0


func process_physics(_delta: float) -> State:
	frame += 1
	reload_time = randi_range(RELOAD_DELAY_MIN, RELOAD_DELAY_MAX)
	if frame <= reload_time:
		return null

	return aim_and_fire
