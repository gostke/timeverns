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

# what the helly...
var was_on_floor: bool = false

# 50 frames per second
@onready var frame_count: int = int(clone_timer.wait_time * 50)
var frames: Array[Frame]
var curr_frame: int = 0

var clones: Array[Human] = [null, null, null]

@onready var flipper: Flipper = $Flipper
@onready var item_picker: ItemPicker = $Flipper/ItemPicker
@onready var thorns: AnimatedSprite2D = $Thorns

var can_change_anim: bool = true

signal on_loop_reset
signal on_throw
signal on_pick_up
signal on_walk
signal on_jump
signal on_fall

func _ready() -> void:
	clone_timer.start()
	frames.resize(frame_count)

func summon_clone(idx: int) -> void:
	if !clone_timer.is_stopped():
		return
	assert(is_player)
	if clones[idx]:
		clones[idx].call_deferred("queue_free")
		clones[idx] = null
	var clone: Human = human_scene.instantiate()
	# deep copy
	clone.frames = frames.duplicate(true)
	clone.is_player = false
	add_sibling(clone)
	clone.global_position = clone.frames[0].global_pos
	clone.flipper.flipped = clone.frames[0].flipped
	clone.sprite.flip_h = clone.frames[0].flipped
	clone.thorns.flip_h = clone.frames[0].flipped
	clone.thorns.visible = true
	clone.sprite.get_material().set_shader_parameter("new_color", constants.CLONE_COLOURS_VECTOR[idx])
	var new_colour := constants.CLONE_COLOURS[idx]
	new_colour.a = 1
	clone.thorns.modulate = clone.thorns.modulate.blend(new_colour)
	clone.get_node("Timers/CloneTimer").start()
	clones[idx] = clone
	clone_timer.start()
	
func _process(_delta: float) -> void:
	if is_player:
		if Input.is_action_just_pressed("clone_0"):
			summon_clone(0)
		if Input.is_action_just_pressed("clone_1"):
			summon_clone(1)
		if Input.is_action_just_pressed("clone_2"):
			summon_clone(2)
	
	if !is_zero_approx(velocity.x):
		if velocity.x < 0:
			sprite.flip_h = false
			thorns.flip_h = false
			flipper.flip(false)
		else:
			sprite.flip_h = true
			thorns.flip_h = true
			flipper.flip(true)
		# sins
		if can_change_anim:
			sprite.play("walk")
			thorns.play("walk")
		if is_zero_approx(velocity.y):
			on_walk.emit()
	else:
		# sin 2
		if can_change_anim:
			sprite.play("stand")
			thorns.play("stand")
	
	if !is_on_floor():
		if velocity.y < 0:
			if can_change_anim:
				sprite.play("jump")
				thorns.play("jump")
			if was_on_floor:
				on_jump.emit()
		else:
			if can_change_anim:
				sprite.play("fall")
				thorns.play("fall")
	# game jam code.........
	if is_on_floor():
		if !was_on_floor:
			on_fall.emit()
	was_on_floor = is_on_floor()		
		
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
	new_frame.flipped = flipper.flipped
	new_frame.animation = sprite.animation
	new_frame.anim_frame = sprite.frame
	
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
		if !drop_timer.is_stopped():
			use_and_add_action(ActionThrowItem.new(), frame)
			drop_timer.stop()
	if Input.is_action_pressed("drop") and drop_timer.is_stopped():
		use_and_add_action(ActionDropItem.new(), frame)
	if Input.is_action_just_pressed("use"):
			use_and_add_action(ActionPickItem.new(), frame)
		
func use_and_add_action(action: Action, frame: Frame) -> void:
	action.use(self)
	frame.add_action(action)
	
func handle_clone() -> void:
	if frames.is_empty():
		return
	# don't ask why (I don't know)
	if !frames[curr_frame]:
		return
	frames[curr_frame].run_actions(self)
	curr_frame += 1
	if curr_frame >= frame_count:
		on_loop_reset.emit()
		curr_frame = 0
		global_position = frames[0].global_pos
		flipper.flip(frames[0].flipped)
		sprite.flip_h = frames[0].flipped
		thorns.flip_h = frames[0].flipped
		


func _on_animated_sprite_2d_animation_finished() -> void:
	if sprite.animation == "throw":
		can_change_anim = true
