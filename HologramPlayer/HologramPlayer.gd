extends KinematicBody2D

const PlayerGun = preload("res://Guns/Pistol.tscn")

export var ACCELERATION := 500
export var MAX_SPEED := 100
export var FRICTION := 500
export var SPAWN_WITH_GUN := false
export var THROW_FORCE := 500

var velocity = Vector2.ZERO
var playerGun = null
var overlappingGuns = []
var throwingGun = false

onready var headAnimationPlayer = $HeadAnimationPlayer
onready var torsoAnimationPlayer = $TorsoAnimationPlayer
onready var feetAnimationPlayer = $FeetAnimationPlayer
onready var feetSprite = $FeetSprite
onready var feetSpriteDefaultRotation = feetSprite.rotation
onready var torsoSprite = $TorsoSprite
onready var torsoSpriteDefaultRotation = torsoSprite.rotation
onready var headSprite = $HeadSprite
onready var headSpriteDefaultRotation = headSprite.rotation
onready var replayer = $Replayer

# TODO: Don't instantiate the gun on init
func _ready():
	if SPAWN_WITH_GUN:		
		pickupPlayerGun(PlayerGun.instance())

func _physics_process(delta):
	# Base movement off of replay recording
	var input_vector = replayer.get_input_vector()
	if input_vector != Vector2.ZERO:
		velocity = velocity.move_toward(input_vector * MAX_SPEED, ACCELERATION * delta)
	else:
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
	
	move()
	
	if not throwingGun and replayer.get_gun_dropped():
		if playerGun == null and !overlappingGuns.empty():
			pickupPlayerGun(overlappingGuns[0])
		elif playerGun != null and !overlappingGuns.empty():
			var gunToPickup = overlappingGuns[0]
			dropPlayerGun()
			pickupPlayerGun(gunToPickup)
		elif playerGun != null:
			dropPlayerGun()
			
	var isGunThrown = replayer.get_gun_thrown()
	if not throwingGun and isGunThrown:
		if playerGun != null:
			throwingGun = true
			look_at(isGunThrown)
			torsoAnimationPlayer.play("ThrowingGun")

	# If the player originally fired at this time, and the hologram can fire,
	# shoot a bullet!
	var shot_fired = replayer.get_shots_fired()
	if playerGun != null and shot_fired and playerGun.canFire():
		look_at(shot_fired)
		playerGun.fire(shot_fired)
		torsoAnimationPlayer.play("HoldingGunFiring")
		headAnimationPlayer.play("FiringHead")
		
	update_animation(input_vector)

func update_animation(input_vector):
	if input_vector != Vector2.ZERO:
		feetSprite.global_rotation = feetSpriteDefaultRotation + input_vector.angle()
			
		feetAnimationPlayer.play("WalkingFeet")
		if playerGun == null:
			torsoAnimationPlayer.play("WalkingTorso")
	else:
		feetAnimationPlayer.play("IdleFeet")
		if playerGun == null:
			torsoAnimationPlayer.play("IdleTorso")


func move():
	velocity = move_and_slide(velocity)

func pickupPlayerGun(instance):
	if playerGun == null:
		instance.pickup(self, 2, true)
		playerGun = instance
		torsoAnimationPlayer.play("HoldingGunIdle")
		overlappingGuns.erase(instance)
		
func dropPlayerGun():
	if playerGun != null:
		playerGun.drop(get_tree().current_scene, global_position, global_rotation)
		playerGun = null

func throwPlayerGun():
	if playerGun != null:
		var throwDirection = get_transform().basis_xform(Vector2.RIGHT)
		playerGun.throw(get_tree().current_scene, global_position, global_rotation, throwDirection * THROW_FORCE)
		playerGun = null

func _on_GunPickupRange_area_entered(area):
	overlappingGuns.append(area.get_parent())


func _on_GunPickupRange_area_exited(area):
	overlappingGuns.erase(area.get_parent())
	
func finishPlayerThrow():
	throwingGun = false
