extends CharacterBody3D

@onready var stateMachine = $StateMachine
@onready var bump: Node = $StateMachine/Bump

@warning_ignore("unused_signal")
signal player_bumped

func _ready() -> void:
	GameMaster.player = self
	safe_margin = 0.015
	floor_max_angle = PI / 6
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
	
## Sets the player in the bump state
## direction The Vector3 representing the direction from wich the player was hurt
func hurt(direction: Vector3) -> void:
	#velocity = direction.normalized() * velocity.length()
	bump.enter_args.push_back(direction)
	stateMachine.change_state(bump)
