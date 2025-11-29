extends CharacterBody2D
class_name Human

@export var is_player: bool = false
@export var speed: float = 5
@export var jump_force: float = 10
@export var mass: float = 1
@export_range(0, 1, 0.01) var drag: float = 0.9
@onready var gravity: float = ProjectSettings.get_setting("physics/2d/default_gravity")

@onready var clone_timer: Timer = $CloneTimer

@onready var human_scene:= preload("uid://efahif683vjg")

# 50 frames per second
@onready var frame_count: int = int(clone_timer.wait_time * 50)
var frames: Array[Frame]


func summon_clone() -> void:
	assert(is_player)
	var clone: Human = human_scene.instantiate()
	# deep copy
	clone.frames = frames.duplicate(true)
	add_sibling(clone)
	clone.global_position = clone.frames[0].global_pos
	clone.get_node("CloneTimer").start()
	
func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("clone") and is_player:
		summon_clone()

func _physics_process(_delta: float) -> void:
	velocity.x *= drag
	
	if is_player:
		handle_player()
	else:
		handle_clone()
		
	velocity.y += gravity * mass * 0.001
	move_and_slide()
	
func handle_player() -> void:
	# recording
	var new_frame: Frame = Frame.new(global_position)
	
	movement(new_frame)
	jumping(new_frame)
	
	frames.push_back(new_frame)
	if frames.size() >= frame_count:
		frames.pop_front()
		
func movement(frame: Frame) -> void:
	var direction_x: float = Input.get_axis("left", "right")
	var move_action: ActionMove = null
	if direction_x != 0:
		move_action = ActionMove.new(Vector2(direction_x, 0), speed) 
	if !move_action:
		return
	move_action.use(self)
	frame.add_action(move_action)
	
func jumping(frame: Frame) -> void:
	if Input.is_action_just_pressed("up"):
		var new_action: ActionJump = ActionJump.new()
		new_action.use(self)
		frame.add_action(new_action)
	
func handle_clone() -> void:
	if frames.is_empty():
		return
	frames.pop_front().run_actions(self)


func _on_clone_timer_timeout() -> void:
	call_deferred("queue_free")
