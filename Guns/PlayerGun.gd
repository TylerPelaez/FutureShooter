extends Sprite

const DefaultProjectile = preload("res://Guns/PlayerProjectile.tscn")

export var BULLET_SPEED := 500
export var MAX_AMMO := 10
onready var ammoCount = MAX_AMMO

onready var fireTimer = $FireTimer
onready var muzzle = $Muzzle

var mask = 0

func canFire():
	return ammoCount > 0 and fireTimer.time_left <= 0

func fire(targetPosition):
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

func setMask(index):
	mask = index
