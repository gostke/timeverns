extends Node2D

@onready var human: Human = $".."
var traces: Array[AnimatedSprite2D]
@export var trace_division: int = 10
@onready var trace_count: int
@export var text_temp: Texture
@onready var animated_sprite_2d: AnimatedSprite2D = $"../AnimatedSprite2D"
@onready var clone_timer: Timer = $"../Timers/CloneTimer"
@onready var og_thorns: AnimatedSprite2D = $"../Thorns"
var thorns: AnimatedSprite2D

func _ready() -> void:
	if !human.is_player:
		queue_free()
	thorns = og_thorns.duplicate(15)
	add_child(thorns)
	# irredemable sin
	await get_tree().process_frame
	trace_count = int(human.frame_count / trace_division)
	for i in range(trace_count):
		# if error: it's here
		var new_sprite := animated_sprite_2d.duplicate()
		new_sprite.modulate.a = (float(i) / trace_count) * 0.2 + 0.05
		new_sprite.visible = false
		add_child(new_sprite)
		traces.push_back(new_sprite)
	traces[0].modulate.a = 0.5
	thorns.modulate.a = 0.5
	thorns.visible = false
	
func _process(_delta: float) -> void:
	if clone_timer.is_stopped():
		traces[0].visible = true 
		thorns.visible = true
	if human.frames[0]:
		thorns.global_position = human.frames[0].global_pos + og_thorns.position
		thorns.animation = human.frames[0].animation
		thorns.flip_h = human.frames[0].flipped
		thorns.frame = human.frames[0].anim_frame
	for i in range(trace_count):
		var current_frame := human.frames[i * trace_division]
		if !current_frame:
			continue
		traces[i].global_position = current_frame.global_pos + animated_sprite_2d.position
		traces[i].animation = current_frame.animation
		traces[i].frame = current_frame.anim_frame
		traces[i].flip_h = current_frame.flipped
		
		if i == 0:
			continue
		if traces[i].global_position.distance_to(traces[i-1].global_position) < 1:
			traces[i].visible = false
		else:
			traces[i].visible = true
		# modulation
		traces[i].self_modulate.a = (clone_timer.wait_time - clone_timer.time_left) / clone_timer.wait_time
			
			
