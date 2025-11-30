extends Area2D

@export var next_level_id:int 
@export var switch: Switch
@export var always_active: bool = false

func _ready() -> void:
	$AnimatedSprite2D.play("closed")
	
func _physics_process(_delta: float) -> void:
	
	if always_active or switch.is_pressed:
		$AnimatedSprite2D.play("opened")
	else:
		$AnimatedSprite2D.play("closed")
		
func _on_body_entered(_body: Node2D) -> void:
	
	if always_active or switch.is_pressed:
		LevelManager.change_level(next_level_id)
