extends "res://Enemies/Enemy.gd"

const EnemyGun = preload("res://Guns/Pistol.tscn")
# This is always true?
const SPAWN_WITH_GUN = true
export var ROTATION_SPEED := 100.0

var enemyGun = null

onready var tween = $Tween
onready var playerDetectionZone = $PlayerDetectionZone
onready var animationPlayer = $AnimationPlayer

func _ready():
	if SPAWN_WITH_GUN:
		spawnEnemyGun()

func _physics_process(delta):
	if playerDetectionZone.isAwareOfPlayer():
		var playerPosition = playerDetectionZone.getPlayerPosition()
		turn(playerPosition)
		if enemyGun != null and enemyGun.canFire():
			enemyGun.fire(playerPosition)
			animationPlayer.play("Firing")
	
func turn(targetPosition):
	var initial_transform = Vector2(global_position.x, global_position.y)
	var duration = abs(targetPosition.x - initial_transform.x) / ROTATION_SPEED
	
	# interpolate
	tween.interpolate_method(self, 'look_at', initial_transform, targetPosition,  duration, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween.start()
	
func spawnEnemyGun():
	enemyGun = EnemyGun.instance()
	enemyGun.pickup(self, 3, false)
	enemyGun.ammoCount
