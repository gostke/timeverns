extends Action
class_name ActionThrowItem

func use(human: Human) -> void:
	human.item_picker.throw()
