extends Area2D
class_name ItemPicker

@export var throw_force: float = 10

@onready var hand: Marker2D = $Hand
@onready var human: Human = $"../.."

var item: Item = null

func _ready() -> void:
	human.on_loop_reset.connect(reset)

func use_item() -> void:
	if !item:
		return
	item.use()

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
		item.reparent(get_tree().current_scene.get_node("Items"))
		item.picked = false
		item.freeze = false
		item.apply_central_impulse(human.velocity * human.SPEED_MULTIPLIER)
		item = null

func throw() -> void:
	if item:
		item.apply_central_impulse(Vector2.RIGHT * throw_force * 100)
		drop()

func reset() -> void:
	drop()
