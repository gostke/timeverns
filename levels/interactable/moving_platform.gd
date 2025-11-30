extends PathFollow2D

@export var speed: float = 16
@export var switch: Switch
@export var always_active: bool = false
@export var looping: bool = false

func _ready() -> void:
	if always_active:
		looping = true

func _physics_process(_delta: float) -> void:
	if (switch and switch.is_pressed) or always_active:
		progress += speed
	elif !looping:
		progress -= speed
	if looping:
		if progress_ratio >= 1 or progress_ratio <= 0:
			speed *= -1
