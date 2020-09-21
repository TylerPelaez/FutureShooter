extends "res://Guns/Gun.gd"

onready var animationPlayer = $AnimationPlayer
onready var pickupSoundEffects = $PickupSoundEffects
onready var putdownSoundEffects = $PutDownSoundEffects
onready var shootSoundEffects = $ShootSoundEffects
onready var throwSoundEffects = $ThrowSoundEffects
onready var outOfAmmoSoundEffects = $OutOfAmmoSoundEffects

func _physics_process(delta):
	if velocity == Vector2.ZERO and dropped:
		animationPlayer.play("Flashing")

func pickup(newParent, newMask, useAmmo, playSFX):
	.pickup(newParent, newMask, useAmmo, playSFX)
	animationPlayer.play("Hide")
	if playSFX:
		pickupSoundEffects.play_random()
	
func drop(world, newPosition, newRotation):
	.drop(world, newPosition, newRotation)
	animationPlayer.play("Flashing")
	putdownSoundEffects.play_random()

func throw(world, newPosition, newRotation, initialVelocity):
	.throw(world, newPosition, newRotation, initialVelocity)
	shootSoundEffects.stop()
	throwSoundEffects.play_random()
	animationPlayer.play("Idle")

func canFire(playSFX):
	var canFire = .canFire(playSFX)
	if !canFire and fireTimer.time_left <= 0:
		outOfAmmoSoundEffects.play_random()
	return canFire

func fire(targetPosition):
	.fire(targetPosition)
	shootSoundEffects.play_random()
