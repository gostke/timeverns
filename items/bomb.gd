extends Item
class_name Bomb

@onready var fuze: Timer = $Fuze

func on_pick_up() -> void:
	if fuze.is_stopped():
		fuze.start()
	
func on_put_down() -> void:
	pass

func _on_fuze_timeout() -> void:
	queue_free()
