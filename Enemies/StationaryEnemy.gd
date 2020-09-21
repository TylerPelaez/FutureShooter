extends "res://Enemies/Enemy.gd"

const EnemyGun = preload("res://Guns/Pistol.tscn")
const SPAWN_WITH_GUN = true

enum {
	PATROL,
	SEEKING_PLAYER
}

export var ROTATION_SPEED := 100.0

var enemyGun = null
var state = PATROL

onready var tween = $Tween
onready var playerDetectionZone = $PlayerDetectionZone
onready var animationPlayer = $AnimationPlayer
onready var seekPlayerTimer = $SeekPlayerTimer
onready var patrolPoints = $PatrolPoints

func _ready():
	if SPAWN_WITH_GUN:
		spawnEnemyGun()
	var initialDirection = patrolPoints.start_patrol()

	if initialDirection != null:
		look_at(initialDirection)
		
func _physics_process(delta):
	if !dying:
		seek_player()
	
func seek_player():
	var target = playerDetectionZone.getTarget()
	if target != null:
		end_patrol()
		var playerPosition = target.global_position
		turn(playerPosition)
		if enemyGun != null and enemyGun.canFire(false):
			enemyGun.fire(playerPosition)
			animationPlayer.play("Firing")

func end_patrol():
	state = SEEKING_PLAYER
	seekPlayerTimer.start()
	patrolPoints.stop_patrol()

func turn(targetPosition):
	var initial_transform = Vector2(global_position.x, global_position.y)
	var duration = abs(targetPosition.x - initial_transform.x) / ROTATION_SPEED
	
	# interpolate
	tween.interpolate_method(self, 'look_at', initial_transform, targetPosition,  duration, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween.start()
	
func spawnEnemyGun():
	enemyGun = EnemyGun.instance()
	enemyGun.pickup(self, 3, false, true)
	enemyGun.ammoCount

func _on_PatrolPoints_new_patrol_point(newPoint):
	if state == PATROL:
		look_at(newPoint)

func _on_SeekPlayerTimer_timeout():
	state = PATROL
	patrolPoints.start_patrol()

func dropEnemyGun():
	if enemyGun != null:
		enemyGun.drop(get_tree().current_scene, global_position, global_rotation)
		enemyGun = null

func _on_EnemyStats_enemy_died_Stationary():
		dropEnemyGun()
