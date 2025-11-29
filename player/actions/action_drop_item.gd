extends Action
class_name ActionDropItem

func use(human: Human) -> void:
	human.item_picker.drop()
