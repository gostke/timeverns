extends Switch

func _physics_process(_delta: float) -> void:
	if $Area2D.get_overlapping_bodies().is_empty():
		is_pressed = false
	else:
		is_pressed = true
