extends Node2D

var velocity = Vector2.ZERO
onready var hitbox = $Hitbox

func _physics_process(delta):
	position += velocity * delta

func setMask(index):
	# See https://godotengine.org/qa/17896/collision-layer-and-masks-in-gdscript
	hitbox.collision_mask = 0
	hitbox.set_collision_mask_bit(index, true)

func _on_Hitbox_area_entered(_area):
	queue_free()

func _on_Hitbox_body_entered(_body):
	queue_free()
