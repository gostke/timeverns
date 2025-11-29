extends PathFollow2D

@export var speed: float = 16
@export var switch: Switch
@export var always_active: bool = false

func _ready() -> void:
	if always_active:
		loop = true

func _physics_process(_delta: float) -> void:
	if (switch and switch.is_pressed) or always_active:
		progress += speed
	else:
		progress -= speed
