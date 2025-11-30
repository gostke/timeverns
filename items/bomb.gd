extends Item
class_name Bomb

@onready var fuze: Timer = $Fuze
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var boom: AnimatedSprite2D = $Boom
@onready var explosion_radius: Area2D = $ExplosionRadius

func _ready() -> void:
	boom.pause()

func on_pick_up() -> void:
	if fuze.is_stopped():
		fuze.start()
		animation_player.play("lit")
	
func on_put_down() -> void:
	pass

func _on_fuze_timeout() -> void:
	boom.reparent(get_tree().current_scene.get_node("Entities"))
	boom.visible = true
	boom.play("boom")
	for body in explosion_radius.get_overlapping_bodies():
		if !body is Breakable:
			continue
		body.destroy()
	call_deferred("queue_free")
