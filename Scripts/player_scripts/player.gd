extends CharacterBody3D

@onready var stateMachine = $StateMachine
@onready var bump: Node = $StateMachine/Bump

var attacks : Array[PlayerState.Attacks] # the attacks this player has equiped (min 1, max 3)
var has_dashed_air : bool # if the player has dashed in the air before
var invincible_time : float # how long the player should ignore incoming attacks
var parrying : bool # if the player is attempting a parry this frame
@warning_ignore("unused_signal")
signal player_bumped
signal parried_attack


func _ready() -> void:
	GameMaster.player = self
	has_dashed_air = false
	safe_margin = 0.1
	wall_min_slide_angle = 0.13
	floor_max_angle = PI / 6
	stateMachine.init(self)
	set_new_attack(PlayerState.Attacks.SPIN)
	set_new_attack(PlayerState.Attacks.DASH)
	set_new_attack(PlayerState.Attacks.PARRY)
 

func _physics_process(delta: float) -> void:
	stateMachine.process_physics(delta)
	if has_dashed_air && is_on_floor():
		has_dashed_air = false


func _process(delta: float) -> void:
	stateMachine.process_frame(delta)
	if invincible_time > 0:
		invincible_time -= delta


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
			PlayerState.Attacks.PARRY:
				master_node = load("uid://cefqlj5jic863").instantiate()
			PlayerState.Attacks.DASH:
				master_node = load("uid://35gr8wj8571o").instantiate()
			PlayerState.Attacks.PUNCH:
				master_node = load("uid://w2avl1jhssm3").instantiate()
			PlayerState.Attacks.CLAP:
				master_node = load("uid://wsev4ap6ovn8").instantiate()
			
		master_node.name = str("Attack", attacks.size())
		master_node.parent = self
		stateMachine.add_child(master_node)
		attacks.push_back(attack)


## Sets the player in the bump state
## direction The Vector3 representing the direction from wich the player was hurt
func hurt(direction: Vector3) -> void:
	#velocity = direction.normalized() * velocity.length()
	if invincible_time > 0:
		return
	if parrying:
		parried_attack.emit(direction)
		return
	bump.enter_args.push_back(direction)
	stateMachine.change_state(bump)
