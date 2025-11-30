extends Area2D

@export var is_open: bool = false
@export var next_level_id:int 

func _ready() -> void:
	$AnimatedSprite2D.play("closed")
	
func _physics_process(_delta: float) -> void:
	
	if is_open:
		$AnimatedSprite2D.play("opened")
		
func _on_body_entered(_body: Node2D) -> void:
	
	if is_open:
		LevelManager.change_level(next_level_id)
