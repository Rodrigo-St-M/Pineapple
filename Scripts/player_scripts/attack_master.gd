extends PlayerState
@onready var ground: PlayerState = $Ground
@onready var air: PlayerState = $Air
var current_state: PlayerState

func _ready() -> void:
	for child in get_children() :
		child.parent = parent

func enter() -> void:
	if parent.is_on_floor():
		current_state = ground
		ground.enter()
	else:
		current_state = air
		air.enter()

func process_frame(_delta: float) -> State:
	return current_state.process_frame(_delta)

func process_physics(_delta: float) -> State:
	return current_state.process_physics(_delta)

func process_input(_event: InputEvent) -> State:
	return current_state.process_input(_event)

func exit() -> void:
	return current_state.exit()
