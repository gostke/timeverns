extends AnimatedSprite2D

func _ready() -> void:
	visible = false

func _on_animation_finished() -> void:
	queue_free()
