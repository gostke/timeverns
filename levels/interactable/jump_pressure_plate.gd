extends Switch

var is_visited: bool = false

func _ready() -> void:
	$Unpressed.visible = true
	$Pressed.visible = false

func _on_area_2d_body_entered(_body: Node2D) -> void:
	
	if not is_visited:
		
		if is_pressed == false:
			$pressed.play()
			
		$Timer.start()
		is_pressed = true
		is_visited = true
		switch_sprites()
		

func _on_area_2d_body_exited(_body: Node2D) -> void:
	
	is_visited = false
	

func _on_timer_timeout() -> void:
	is_pressed = false
	switch_sprites()
	$unpressed.play()

func switch_sprites() -> void:
	$Unpressed.visible = not is_pressed
	$Pressed.visible = is_pressed
