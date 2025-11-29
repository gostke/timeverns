extends Action
class_name ActionMove

var direction_: Vector2
var speed_: float

func _init(direction: Vector2, speed: float) -> void:
	direction_ = direction
	speed_ = speed

func use(human: Human) -> void:
	assert(direction_)
	assert(speed_)
	# for now TODO change this
	human.velocity.x = 0
	human.velocity += direction_ * speed_
