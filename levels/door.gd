extends Area2D

var is_open: bool = true 
@export var next_level_id:int 
	
func _on_body_entered(_body: Node2D) -> void:
	
	if is_open:
		LevelManager.change_level(next_level_id)
