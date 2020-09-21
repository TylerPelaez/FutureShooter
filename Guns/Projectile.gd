extends KinematicBody2D

const EntityImpactSoundEffects = preload("res://SFX/EntityImpactSoundEffects.tscn")
const BulletImpactSoundEffects = preload("res://SFX/BulletImpactSoundEffects.tscn")

var velocity = Vector2.ZERO
onready var hitbox = $Hitbox

func _physics_process(delta):
	var collision = move_and_collide(velocity * delta)
	if collision != null:
		var instance = BulletImpactSoundEffects.instance()
		instance.one_shot = true
		instance.play_random()
		get_tree().current_scene.add_child(instance)
		instance.global_position = global_position
		queue_free()

func setMask(index):
	# See https://godotengine.org/qa/17896/collision-layer-and-masks-in-gdscript
	# By default, everything should collide with the world
	hitbox.collision_mask = pow(2, 0)
	hitbox.set_collision_mask_bit(index, true)

func _on_Hitbox_area_entered(area):
	var instance = EntityImpactSoundEffects.instance()
	instance.one_shot = true
	instance.play_random()
	get_tree().current_scene.add_child(instance)
	instance.global_position = global_position
	queue_free()

func _on_Hitbox_body_entered(body):
	var instance = EntityImpactSoundEffects.instance()
	instance.one_shot = true
	instance.play_random()
	get_tree().current_scene.add_child(instance)
	instance.global_position = global_position
	queue_free()
