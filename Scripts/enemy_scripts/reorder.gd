extends State

const INIT_Y_SPEED: int = 1
const MAX_Y_SPEED: int = 10
var init_height: float
var tower: Array
var index: int
var new_position: Vector3
@onready var follow_below: State = $"../FollowBelow"
@onready var aproach_stacker: Node = $"../Aproach"
@onready var escape_stacker: Node = $"../Escape"

func enter() -> void:
	tower = parent.tower
	index = parent.tower_index
	parent.velocity.y = INIT_Y_SPEED
	parent.set_collision_mask_value(1, false)

func process_physics(_delta: float) -> State:
	var state = null
	
	for i in parent.get_slide_collision_count():
		var collider : Object = parent.get_slide_collision(i).get_collider()
		if parent.piece_below:
			if collider.get_instance_id() == parent.piece_below.get_instance_id():
				state = follow_below
		elif parent.is_on_floor() && collider.is_class("StaticBody3D"):
			if tower[0].holding_pineapple:
				state = escape_stacker
			else:
				state = aproach_stacker
				
	if parent.piece_below:
		new_position = parent.piece_below.position
		parent.position.x = new_position.x
		parent.position.z = new_position.z
		parent.velocity.x = parent.piece_below.velocity.x
		parent.velocity.z = parent.piece_below.velocity.z
		
	parent.velocity.y -= parent.get_gravity().length() * _delta
	if parent.velocity.y < -MAX_Y_SPEED:
		parent.velocity.y = MAX_Y_SPEED
	parent.move_and_slide()
	
	return state
	
func exit() -> void:
	parent.set_collision_mask_value(1, true)
