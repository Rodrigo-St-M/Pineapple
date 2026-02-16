#class_name StackerPiece
#extends Enemy
#
#var stacker_array: Array
#var piece_above : StackerPiece
#var piece_below : StackerPiece
#var stacker_array_index: int
#
#
##func get_class():
	##return "StackerPiece"
##
##func is_class(name): 
	##return name == "StackerPiece" or is_class(name) 
