extends Node2D

func _physics_process(_delta: float) -> void:
	
	if $Entities/PressurePlate.is_pressed:
		$Portal.is_open = true
	else:
		$Portal.is_open = false
