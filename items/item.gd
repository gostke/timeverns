@abstract
extends RigidBody2D
class_name Item

var picked: bool = false

@abstract func use() -> void
@abstract func on_pick_up() -> void
@abstract func on_put_down() -> void
