extends Node2D

func _physics_process(_delta: float) -> void:
	
	if $Environment/PressurePlate.is_pressed:
		$Environment/Door.is_open = true
	else:
		$Environment/Door.is_open = false
