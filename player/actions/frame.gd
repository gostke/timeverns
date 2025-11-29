extends Resource
class_name Frame

var actions_: Array[Action]
var global_pos: Vector2

func _init(global_position: Vector2) -> void:
	global_pos = global_position

func add_action(action: Action) -> void:
	actions_.push_back(action)
	
func run_actions(human: Human) -> void:
	for action in actions_:
		action.use(human)
