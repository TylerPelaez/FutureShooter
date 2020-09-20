extends "res://Guns/Gun.gd"

onready var animationPlayer = $AnimationPlayer

func _physics_process(delta):
	if velocity == Vector2.ZERO and dropped:
		animationPlayer.play("Flashing")

func pickup(newParent, newMask, useAmmo):
	.pickup(newParent, newMask, useAmmo)
	animationPlayer.play("Hide")
	
func drop(world, newPosition, newRotation):
	.drop(world, newPosition, newRotation)
	animationPlayer.play("Flashing")

func throw(world, newPosition, newRotation, initialVelocity):
	.throw(world, newPosition, newRotation, initialVelocity)
	animationPlayer.play("Idle")
