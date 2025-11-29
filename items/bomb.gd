extends Item
class_name Bomb

@onready var fuze: Timer = $Fuze
@onready var animation_player: AnimationPlayer = $AnimationPlayer

func on_pick_up() -> void:
	if fuze.is_stopped():
		fuze.start()
		animation_player.play("lit")
	
func on_put_down() -> void:
	pass

func _on_fuze_timeout() -> void:
	queue_free()
