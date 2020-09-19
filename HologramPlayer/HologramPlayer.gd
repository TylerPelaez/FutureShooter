extends KinematicBody2D

const PlayerGun = preload("res://Guns/PlayerGun.tscn")

export var ACCELERATION := 500
export var MAX_SPEED := 100
export var FRICTION := 500
export var SPAWN_WITH_GUN := true

var velocity = Vector2.ZERO
var playerGun = null

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
		spawnPlayerGun()

func _physics_process(delta):
	# Base movement off of replay recording
	var input_vector = replayer.get_input_vector()
	if input_vector != Vector2.ZERO:
		velocity = velocity.move_toward(input_vector * MAX_SPEED, ACCELERATION * delta)
	else:
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
	
	move()
	# TODO: Facing recording
	# faceMouse()
	update_animation(input_vector)

# TODO: Firing recording	
#	if playerGun != null and Input.is_action_pressed("fire") and playerGun.canFire():
#		playerGun.fire(get_global_mouse_position())
#		torsoAnimationPlayer.play("HoldingGunFiring")
#		headAnimationPlayer.play("FiringHead")

func update_animation(input_vector):
	if input_vector != Vector2.ZERO:
		feetSprite.global_rotation = feetSpriteDefaultRotation + input_vector.angle()
		torsoSprite.global_rotation = torsoSpriteDefaultRotation + input_vector.angle()
		headSprite.global_rotation = headSpriteDefaultRotation + input_vector.angle()
		feetAnimationPlayer.play("WalkingFeet")
		if playerGun == null:
			torsoAnimationPlayer.play("WalkingTorso")
	else:
		feetAnimationPlayer.play("IdleFeet")
		if playerGun == null:
			torsoAnimationPlayer.play("IdleTorso")


func move():
	velocity = move_and_slide(velocity)

func faceMouse():
	var mousePosition = get_global_mouse_position()	
	look_at(mousePosition)

func spawnPlayerGun():
	playerGun = PlayerGun.instance()
	add_child(playerGun)
	playerGun.global_position = global_position
	playerGun.rotation = rotation
	playerGun.setMask(2)
	torsoAnimationPlayer.play("HoldingGunIdle")
