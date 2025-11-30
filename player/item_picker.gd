extends Area2D
class_name ItemPicker

@export var throw_force: Vector2 = Vector2.RIGHT

@onready var hand: Marker2D = $Hand
@onready var human: Human = $"../.."
@onready var flipper: Flipper = $".."

var item: Item = null

func _ready() -> void:
	human.on_loop_reset.connect(reset)

func pick_up() -> void:
	var items:= get_overlapping_bodies()
	if items.is_empty():
		return
	items.sort_custom(func(lhs, rhs): 
		return lhs.global_position.distance_to(human.global_position) < rhs.global_position.distance_to(human.global_position)
		)
	var new_item: Item = null
	for it in items:
		if !it.picked:
			new_item = it
			break
	if !new_item:
		return
	item = new_item
	item.reparent(hand)
	item.global_position = hand.global_position
	item.picked = true
	item.freeze = true
	item.on_pick_up()
	
func drop() -> void:
	if item:
		remove_item().apply_central_impulse(human.velocity * human.SPEED_MULTIPLIER)

func remove_item() -> Item:
	item.reparent(get_tree().current_scene.get_node("Items"))
	item.picked = false
	item.freeze = false
	var old_item := item
	item = null
	return old_item

func throw() -> void:
	if item:
		human.on_throw.emit()
		human.can_change_anim = false
		human.sprite.play("throw")
		human.thorns.play("throw")
		var throw_dir := Vector2(1, 1)
		if !flipper.flipped:
			throw_dir.x = -1
		remove_item().apply_central_impulse(throw_force * throw_dir)

func reset() -> void:
	drop()
