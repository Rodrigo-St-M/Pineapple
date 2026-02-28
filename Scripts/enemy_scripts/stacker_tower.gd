extends Node3D

const STACKER = preload("uid://7kni3adtvvl0")
const STACKER_BALL = preload("uid://ipx8d0sk44my")

var previous_state: State

var tower: Array
var size: int
var is_destroying: bool = false

func _ready() -> void:
	position.y += 5
	tower.push_front(STACKER.instantiate())
	tower[0].tower = self.tower
	tower[0].position = position
	add_child(tower[0])
	
	tower[0].defeat_exit.connect(_on_defeat_exit)
	
	var num_balls = randi_range(3, 4)
	size = num_balls +1
	for i in range(num_balls):
		tower.push_back(STACKER_BALL.instantiate())
		add_child(tower[i+1])
		tower[i].piece_below = tower[i+1]
		tower[i+1].piece_above = tower[i]
		tower[i+1].tower = self.tower
		tower[i+1].tower_index = i + 1
		tower[i+1].position = position
		tower[i+1].position.y -= i + 1
	
	for i in tower.size() -1:
		tower[i].destroy_tower.connect(_on_destroy_tower)
		tower[i].enter_state(Enemy.States.FOLLOW)
	tower[tower.size()-1].enter_state(Enemy.States.SPAWN)
	

func _on_defeat_exit() -> void:
	#print("tower is freeing")
	queue_free()

func _on_destroy_tower() -> void:
	if is_destroying:
		#print("tower cancelled destruction repeat attempt")
		return
	is_destroying = true
	#print("tower is destroying")
	
	for piece in tower:
		if piece && piece.get_current_state() != Enemy.States.DEFEAT:
			piece.enter_state(Enemy.States.DEFEAT)
