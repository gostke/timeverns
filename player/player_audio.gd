extends AudioStreamPlayer2D

@onready var human: Human = $".."
@export var jump_sounds: Array[AudioStream]
@export var walk_sounds: Array[AudioStream]
@export var pick_sound: AudioStream
@export var throw_sound: AudioStream

func _ready() -> void:
	human.on_walk.connect(
		func():
			if !playing:
				stream = walk_sounds[randi_range(0, walk_sounds.size() - 1)]
				play()
	)
	# human.on_fall.connect(func(): play_random_sound(fall_sound))
	human.on_jump.connect(func(): play_random_sound(jump_sounds))
	human.on_throw.connect(func(): stream = throw_sound; play())

func play_random_sound(sounds: Array[AudioStream]) -> void:
	stream = sounds[randi_range(0, walk_sounds.size() - 1)]
	play()
