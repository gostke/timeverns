extends Node2D

@onready var human: Human = $".."
var traces: Array[Sprite2D]
@export var trace_division: int = 10
@onready var trace_count: int
@export var text_temp: Texture
@onready var animated_sprite_2d: AnimatedSprite2D = $"../AnimatedSprite2D"
@onready var clone_timer: Timer = $"../Timers/CloneTimer"

func _ready() -> void:
	if !human.is_player:
		queue_free()
	# irredemable sin
	await get_tree().process_frame
	trace_count = int(human.frame_count / trace_division)
	for i in range(trace_count):
		var new_sprite := Sprite2D.new()
		new_sprite.texture = text_temp
		new_sprite.scale = animated_sprite_2d.scale
		new_sprite.position = animated_sprite_2d.position
		new_sprite.modulate.a = (float(i) / trace_count) * 0.2 + 0.05
		new_sprite.visible = false
		add_child(new_sprite)
		traces.push_back(new_sprite)
	traces[0].modulate.a = 0.5
	
func _process(_delta: float) -> void:
	if clone_timer.is_stopped():
		traces[0].modulate.r = 0.5
		traces[0].modulate.g = 0.7
		traces[0].modulate.b = 0.5
		traces[0].visible = true
	else:
		traces[0].modulate.r = 1
		traces[0].modulate.g = 1
		traces[0].modulate.b = 1
	
	for i in range(trace_count):
		if !human.frames[i * trace_division]:
			continue
		traces[i].global_position = human.frames[i * trace_division].global_pos + animated_sprite_2d.position
		if i == 0:
			continue
		if traces[i].global_position.distance_to(traces[i-1].global_position) < 1:
			traces[i].visible = false
		else:
			traces[i].visible = true
		# modulation
		traces[i].self_modulate.a = (clone_timer.wait_time - clone_timer.time_left) / clone_timer.wait_time
			
			
