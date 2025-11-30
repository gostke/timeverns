extends StaticBody2D
class_name Breakable

func destroy() -> void:
	call_deferred("queue_free")
