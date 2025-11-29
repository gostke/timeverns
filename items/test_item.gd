extends Item

func use() -> void:
	print("used!")
	
func on_pick_up() -> void:
	print("picked up!")
	
func on_put_down() -> void:
	print("put down!")
