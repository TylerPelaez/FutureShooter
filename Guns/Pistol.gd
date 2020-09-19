extends "res://Guns/Gun.gd"

onready var animationPlayer = $AnimationPlayer
onready var dropTimer = $DropTimer	

func pickup(newParent, newMask, useAmmo):
	.pickup(newParent, newMask, useAmmo)
	animationPlayer.play("Hide")
	
func drop(world, newPosition, newRotation):
	.drop(world, newPosition, newRotation)
	animationPlayer.play("Idle")
	dropTimer.start()

func _on_DropTimer_timeout():
	if dropped:
		animationPlayer.play("Flashing")
