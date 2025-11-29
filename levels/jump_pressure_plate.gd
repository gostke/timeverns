extends Switch

var is_visited: bool = false


func _on_area_2d_body_entered(_body: Node2D) -> void:
	
	if not is_visited:
		$Timer.start()
		is_pressed = true
		is_visited = true
	
	print(is_pressed)

func _on_area_2d_body_exited(_body: Node2D) -> void:
	
	is_visited = false
	

func _on_timer_timeout() -> void:
	is_pressed = false
	print("Time's out: ", is_pressed)
