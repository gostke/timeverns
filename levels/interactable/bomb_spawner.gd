extends Area2D

@onready var bomb_scene := preload("uid://6ci323i4f7tr")
@onready var timer: Timer = $Timer

func _process(_delta: float) -> void:
	var bombs_nearby: bool = get_overlapping_bodies().any(
		func(bomb):
			return bomb is Bomb
	)
	if timer.is_stopped() and !bombs_nearby:
		var new_bomb:= bomb_scene.instantiate()
		get_tree().current_scene.get_node("Items").add_child(new_bomb)
		new_bomb.global_position = global_position
		timer.start()
