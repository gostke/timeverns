extends Action
class_name ActionPickItem

func use(human: Human) -> void:
	human.item_picker.pick_up()
