extends Area2D

@export var next_level_id:int 
@export var switch: Switch
@export var always_active: bool = false

var is_opening: bool = false

func _ready() -> void:
	$AnimatedSprite2D.play("closed")
	
func _physics_process(_delta: float) -> void:
	
	if always_active or switch.is_pressed:
		
		#play sound only once when portal is endactivated
		if is_opening != true:
			$opening.play(0.5)
			await $opening.finished
			$opened.play()
		is_opening = true
		
		$AnimatedSprite2D.play("opened")
	else:
		
		if is_opening != false:
			$closing.play()
			
		is_opening = false
		
		is_opening = false
		$AnimatedSprite2D.play("closed")
		
func _on_body_entered(_body: Node2D) -> void:
	
	if always_active or switch.is_pressed:
		LevelManager.change_level(next_level_id)
