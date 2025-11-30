extends Switch

var is_visited: bool = false


func _on_area_2d_body_entered(_body: Node2D) -> void:
	
	if not is_visited:
		$Timer.start()
		is_pressed = true
		is_visited = true
		switch_sprites()
	
	print(is_pressed)

func _on_area_2d_body_exited(_body: Node2D) -> void:
	
	is_visited = false
	

func _on_timer_timeout() -> void:
	is_pressed = false
	switch_sprites()
	print("Time's out: ", is_pressed)

func switch_sprites() -> void:
	$Unpressed.visible = not is_pressed
	$Pressed.visible = is_pressed
