extends Node


#enum LEVEL_INDEX {LVL1, LVL2}

var level_2: PackedScene = preload("res://levels/level_2.tscn")
var level_3: PackedScene = preload("res://levels/level_3.tscn")

func _ready() -> void:
	$BackgroundMusic.play()

var levels: Dictionary = {
	2 : level_2,
	3: level_3
}

func change_level(next_level_id: int) -> void:
		get_tree().call_deferred("change_scene_to_packed",levels[next_level_id])
