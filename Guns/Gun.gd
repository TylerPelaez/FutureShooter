extends KinematicBody2D

const DefaultProjectile = preload("res://Guns/Projectile.tscn")

export var FRICTION := 500
export var BULLET_SPEED := 1000
export var MAX_AMMO := 2
export var MIN_LETHAL_SPEED := 50
export var THROW_ROTATION_SPEED := .1

onready var ammoCount = MAX_AMMO 
onready var fireTimer = $FireTimer
onready var muzzle = $Muzzle
onready var collider = $Collider
onready var pickupRange = $PickupRange/Collider
onready var gunHitbox = $Hitbox
onready var gunHitboxCollider = $Hitbox/Collider

var usesAmmo = true
var mask = 0
var dropped = true
var velocity = Vector2.ZERO

func _physics_process(delta):
	if velocity != Vector2.ZERO:
		rotation += THROW_ROTATION_SPEED
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
		move()
		if velocity.length() < MIN_LETHAL_SPEED:
			gunHitboxCollider.disabled = true
	
func move():
	var tempVelocity = move_and_slide(velocity)
	
	if get_slide_count() > 0:
		var collision = get_slide_collision(0)
		if collision != null:
			velocity = velocity.bounce(collision.normal) / 2# do ball bounce
	else:
		velocity = tempVelocity

func canFire(playSFX):
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

func pickup(newParent, newMask, useAmmo, playSFX):
	if get_parent() != null:
		get_parent().remove_child(self)
	newParent.add_child(self)
	global_position = newParent.global_position
	global_rotation = newParent.global_rotation
	mask = newMask
	collider.set_deferred("disabled", true)
	dropped = false
	usesAmmo = useAmmo
	pickupRange.set_deferred("disabled", true)
	gunHitboxCollider.set_deferred("disabled", true)
	gunHitbox.set_deferred("collision_mask", pow(2, newMask))

func drop(world, newPosition, newRotation):
	if get_parent() != null:
		get_parent().remove_child(self)
	world.call_deferred("add_child", self)
	global_position = newPosition
	global_rotation = newRotation
	collider.set_deferred("disabled", false)
	dropped = true
	pickupRange.set_deferred("disabled", false)
	pickupRange.set_deferred("disabled", false)

func throw(world, newPosition, newRotation, initialVelocity):
	drop(world, newPosition, newRotation)
	gunHitboxCollider.disabled = false
	velocity = initialVelocity
