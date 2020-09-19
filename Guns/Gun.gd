extends KinematicBody2D

const DefaultProjectile = preload("res://Guns/Projectile.tscn")

export var BULLET_SPEED := 1000
export var MAX_AMMO := 2

onready var ammoCount = MAX_AMMO 
onready var fireTimer = $FireTimer
onready var muzzle = $Muzzle
onready var collider = $Collider
onready var pickupRange = $PickupRange/Collider

var usesAmmo = true
var mask = 0
var dropped = true

func canFire():
	return (!usesAmmo or ammoCount > 0) and fireTimer.time_left <= 0

func fire(targetPosition):
	if usesAmmo:
		ammoCount = max(ammoCount -1, 0)
	instantiateProjectile(targetPosition)
	fireTimer.start()

# Let children implement this function
func instantiateProjectile(targetPosition):
	var projectile = Utils.instance_scene_on_main(DefaultProjectile, muzzle.global_position)
	var directionVector = projectile.global_position.direction_to(targetPosition)
	projectile.velocity = directionVector * BULLET_SPEED
	projectile.rotation = projectile.velocity.angle()
	projectile.setMask(mask)

func pickup(newParent, newMask, useAmmo):
	if get_parent() != null:
		get_parent().remove_child(self)
	newParent.add_child(self)
	global_position = newParent.global_position
	global_rotation = newParent.global_rotation
	mask = newMask
	collider.disabled = true
	dropped = false
	usesAmmo = useAmmo
	pickupRange.disabled = true

func drop(world, newPosition, newRotation):
	if get_parent() != null:
		get_parent().remove_child(self)
	world.add_child(self)
	global_position = newPosition
	global_rotation = newRotation
	collider.disabled = false
	dropped = true
	pickupRange.disabled = false
