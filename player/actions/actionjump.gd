extends Action
class_name ActionJump

func use(human: Human) -> void:
	if !human.is_on_floor():
		return
	human.velocity.y -= human.jump_force
