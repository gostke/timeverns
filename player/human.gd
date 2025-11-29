extends CharacterBody2D
class_name Human

@export var is_player: bool = false
@export var speed: float = 2
@export var jump_force: float = 10
@export var mass: float = 1
@export_range(0, 1, 0.01) var drag: float = 0.9
@onready var gravity: float = ProjectSettings.get_setting("physics/2d/default_gravity")

const SPEED_MULTIPLIER: float = 100

@onready var clone_timer: Timer = $Timers/CloneTimer
@onready var drop_timer: Timer = $Timers/DropTimer
@onready var human_scene:= preload("uid://efahif683vjg")
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D

# 50 frames per second
@onready var frame_count: int = int(clone_timer.wait_time * 50)
var frames: Array[Frame]
var curr_frame: int = 0

@onready var flipper: Flipper = $Flipper
@onready var item_picker: ItemPicker = $Flipper/ItemPicker

signal on_loop_reset

func _ready() -> void:
	clone_timer.start()
	frames.resize(frame_count)

func summon_clone() -> void:
	if !clone_timer.is_stopped():
		return
	assert(is_player)
	var clone: Human = human_scene.instantiate()
	# deep copy
	clone.frames = frames.duplicate(true)
	add_sibling(clone)
	clone.global_position = clone.frames[0].global_pos
	clone.get_node("Timers/CloneTimer").start()
	clone_timer.start()
	
func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("clone_1") and is_player:
		summon_clone()
	
	if !is_zero_approx(velocity.x):
		if velocity.x < 0:
			sprite.flip_h = false
			flipper.flip(false)
		else:
			sprite.flip_h = true
			flipper.flip(true)
		# sin
		sprite.play("walk")
	else:
		# sin 2
		sprite.play("stand")
	
	if !is_on_floor():
		if velocity.y < 0:
			sprite.play("jump")
		else:
			sprite.play("fall")
		
func _physics_process(_delta: float) -> void:
	velocity.x *= drag
	
	if is_player:
		handle_player()
	else:
		handle_clone()
	
	velocity *= SPEED_MULTIPLIER
	velocity.y += gravity * mass * (1.0/SPEED_MULTIPLIER)
	move_and_slide()
	velocity /= SPEED_MULTIPLIER
	
func handle_player() -> void:
	# recording
	var new_frame: Frame = Frame.new(global_position)
	
	movement(new_frame)
	jumping(new_frame)
	interacting(new_frame)
	
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

func interacting(frame: Frame) -> void:
	if Input.is_action_just_pressed("drop"):
		drop_timer.start()
	if Input.is_action_just_released("drop"):
		if drop_timer.is_stopped():
			use_and_add_action(ActionThrowItem.new(), frame)
		else:
			use_and_add_action(ActionDropItem.new(), frame)
	if Input.is_action_just_pressed("use"):
			use_and_add_action(ActionPickItem.new(), frame)
		
func use_and_add_action(action: Action, frame: Frame) -> void:
	action.use(self)
	frame.add_action(action)
	
func handle_clone() -> void:
	if frames.is_empty():
		return
	frames[curr_frame].run_actions(self)
	curr_frame += 1
	if curr_frame >= frame_count:
		on_loop_reset.emit()
		curr_frame = 0
		global_position = frames[0].global_pos
