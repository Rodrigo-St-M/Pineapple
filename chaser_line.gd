extends Node3D
const CHASER = preload("uid://lhus61t1y3rb")

var chaser_array : Array[Enemy]
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var size = randi_range(4, 6)
	for i in range(size):
		chaser_array.push_back(CHASER.instantiate())
		add_child(chaser_array[i])
	
		chaser_array[i].line_array = chaser_array
		chaser_array[i].line_array_index = i
		chaser_array[i].position = position
		chaser_array[i].position.y += 4 * i
	
	for i in range(size - 1):
		chaser_array[i + 1].next_chaser = chaser_array[i]

func _process(_delta: float) -> void:
	for i in chaser_array:
		if i != null:
			return
	
	queue_free()
