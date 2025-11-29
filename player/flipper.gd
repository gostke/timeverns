extends Node2D
class_name Flipper

var flipped: bool = false:
	set(val):
		if val == flipped:
			return
		if val:
			scale.x = -1
		else:
			scale.x = 1
		flipped = val
		
func flip(set_flip: bool) -> void:
	flipped = set_flip
