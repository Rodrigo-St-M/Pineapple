extends State

const INIT_Y_SPEED: int = 1
const MAX_Y_SPEED: int = 10
var init_height: float
var tower: Array
var index: int
@onready var follow_bellow: State = $"../FollowBellow"
@onready var aproach_stacker: Node = $"../AproachStacker"
@onready var escape_stacker: Node = $"../EscapeStacker"

func enter() -> void:
	tower = parent.tower
	index = parent.tower_index
	parent.velocity.y = INIT_Y_SPEED
	print("index " + str(index) + " reordering!")

func process_physics(_delta: float) -> State:
	var state = null
	parent.move_and_slide()
	
	for i in parent.get_slide_collision_count():
		var collider : Object = parent.get_slide_collision(i).get_collider()
		if parent.piece_below:
			if collider.get_instance_id() == parent.piece_below.get_instance_id():
				state = follow_bellow
		elif collider.is_class("StaticBody3D"):
			if tower[0].holding_pineapple:
				state = escape_stacker
			else:
				state = aproach_stacker
	
	parent.velocity.y -= parent.get_gravity().length() * _delta
	if parent.velocity.y < -MAX_Y_SPEED:
		parent.velocity.y = MAX_Y_SPEED
	return state
