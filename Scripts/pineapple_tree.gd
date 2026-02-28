extends StaticBody3D

var pineapples : Array[Node3D]
signal pineapple_stolen
signal pineapple_recovered

@export var pineappleScene : PackedScene

func _ready() -> void:
	GameMaster.pineapple_tree = self
	for i in range(3):
		pineapples.push_back(pineappleScene.instantiate())

		#pineapples[i].name = "apple" + str(i)
		add_child(pineapples[i])
		pineapples[i].position.x += - 1 + 1 * i
		pineapples[i].position.z += 1
		pineapples[i].position.y += 2
		GameMaster.pineapples.push_back(pineapples[i])

## Returns and removes pineapple if the tree has any pineapples left
## If id does not have any pineapples, returns null and does nothing else
## ensures: \return is a pineapple
func steal_pineapple() -> Node3D:
	if pineapples.is_empty():
		return null
	var pineapple = pineapples.pop_back()
	remove_child(pineapple)
	emit_signal("pineapple_stolen")
	return pineapple

## Adds the given pineapple back to this pineapple tree
## pineapple an instance of the pineapple scene
func recover_pineapple(pineapple : Node3D) -> void:
	pineapples.push_back(pineapple)
	emit_signal("pineapple_recovered")
	add_child(pineapple)
	#pineapple.position.x += - 1 + 1 * pineapples.size()
	#pineapple.position.z += 1
	#pineapple.position.y += 2
