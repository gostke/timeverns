extends Node


#enum LEVEL_INDEX {LVL1, LVL2}

var level_1: PackedScene = preload("res://levels/level_1.tscn")
var level_2: PackedScene = preload("res://levels/level_2.tscn")

var levels: Dictionary = {
	1 : level_1,
	2 : level_2
}

func _ready() -> void:
	get_tree().change_scene_to_packed(levels[1])

func change_level(next_level_id: int) -> void:
	get_tree().call_deferred("change_scene_to_packed",levels[next_level_id])
