extends CharacterBody3D

@onready var stateMachine = $StateMachine
@onready var bump: Node = $StateMachine/Bump

var attacks : Array[PlayerState.Attacks]


@warning_ignore("unused_signal")
signal player_bumped

func _ready() -> void:
	GameMaster.player = self
	set_new_attack(PlayerState.Attacks.SPIN)
	safe_margin = 0.015
	floor_max_angle = PI / 6
	stateMachine.init(self)
	set_new_attack(PlayerState.Attacks.SPIN)
	set_new_attack(PlayerState.Attacks.PUNCH)
 
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


func set_new_attack(attack : PlayerState.Attacks) -> void:
	if attacks.size() == 3 || attacks.has(attack):
		return
	else:
		var master_node: PlayerState
		match attack:
			PlayerState.Attacks.SPIN:
				master_node = load("uid://cdkc0rheog2o4").instantiate()
			PlayerState.Attacks.KICK:
				pass
			PlayerState.Attacks.DASH:
				pass
			PlayerState.Attacks.PUNCH:
				master_node = load("uid://w2avl1jhssm3").instantiate()
		master_node.name = str("Attack", attacks.size())
		master_node.parent = self
		stateMachine.add_child(master_node)
		attacks.push_back(attack)


## Sets the player in the bump state
## direction The Vector3 representing the direction from wich the player was hurt
func hurt(direction: Vector3) -> void:
	#velocity = direction.normalized() * velocity.length()
	bump.enter_args.push_back(direction)
	stateMachine.change_state(bump)
