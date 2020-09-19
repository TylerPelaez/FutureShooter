extends KinematicBody2D

const PlayerGun = preload("res://Guns/Pistol.tscn")

export var ACCELERATION := 500
export var MAX_SPEED := 100
export var FRICTION := 500
export var AIM_SPEED := 1
export var CAMERA_POSITION_OFFSET_DENOMINATOR := 4
export var SPAWN_WITH_GUN := false

var velocity = Vector2.ZERO
var playerGun = null
var overlappingGuns = []

onready var gunPickupRange = $GunPickupRange
onready var headAnimationPlayer = $HeadAnimationPlayer
onready var torsoAnimationPlayer = $TorsoAnimationPlayer
onready var feetAnimationPlayer = $FeetAnimationPlayer
onready var cameraFollow = $CameraFollow
onready var feetSprite = $FeetSprite
onready var feetSpriteDefaultRotation = feetSprite.rotation
onready var recorder = $Recorder

func _ready():
	if SPAWN_WITH_GUN:
		pickupPlayerGun(PlayerGun.instance())

func _physics_process(delta):
	var input_vector = get_input_vector()
	if input_vector != Vector2.ZERO:
		velocity = velocity.move_toward(input_vector * MAX_SPEED, ACCELERATION * delta)
	else:
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
	
	move()
	faceMouse()
	update_animation(input_vector)
	moveCameraFollow()
	updateShooting()
	
	if Input.is_action_just_pressed("interact"):
		if playerGun == null and !overlappingGuns.empty():
			pickupPlayerGun(overlappingGuns[0])
		elif playerGun != null and !overlappingGuns.empty():
			var gunToPickup = overlappingGuns[0]
			dropPlayerGun()
			pickupPlayerGun(gunToPickup)
		elif playerGun != null:
			dropPlayerGun()
	
func get_input_vector():
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	input_vector = input_vector.normalized()
	return input_vector

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

func faceMouse():
	var mousePosition = get_global_mouse_position()	
	look_at(mousePosition)
	
func moveCameraFollow():
	var mousePos = get_global_mouse_position()
	var midpoint = (mousePos - global_position) / CAMERA_POSITION_OFFSET_DENOMINATOR
	cameraFollow.global_position = global_position + midpoint

func updateShooting():
	if playerGun != null and Input.is_action_pressed("fire") and playerGun.canFire():
		recorder.log_shot(get_global_mouse_position())
		playerGun.fire(get_global_mouse_position())
		torsoAnimationPlayer.play("HoldingGunFiring")
		headAnimationPlayer.play("FiringHead")

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

func _on_GunPickupRange_area_entered(area):
	overlappingGuns.append(area.get_parent())


func _on_GunPickupRange_area_exited(area):
	overlappingGuns.erase(area.get_parent())
