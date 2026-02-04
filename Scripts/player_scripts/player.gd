extends CharacterBody3D

@onready var stateMachine = $StateMachine


func _ready() -> void:
	GameMaster.player = self
	safe_margin = 0.015
	stateMachine.init(self)

func _physics_process(delta: float) -> void:
	stateMachine.process_physics(delta)

func _process(delta: float) -> void:
	stateMachine.process_frame(delta)

func _unhandled_input(event: InputEvent) -> void:
	stateMachine.process_input(event)
	
## returns a string that represents the current state of this player, 
## requires stateMachine must have been initialized properly
## ensures \return != null
## returns a string indicating the current state
func get_state_name() -> String:
	return str(stateMachine.current_state)
