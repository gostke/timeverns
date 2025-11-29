extends Action
class_name ActionUseItem

func use(human: Human) -> void:
	human.item_picker.use()
