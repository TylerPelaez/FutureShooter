extends "res://Enemies/Enemy.gd"

const EnemyGun = preload("res://Guns/PlayerGun.tscn")

var enemyGun = null
onready var playerDetectionZone = $PlayerDetectionZone

func _ready():
	spawnEnemyGun()

func _physics_process(delta):
	if playerDetectionZone.isAwareOfPlayer():
		var playerPosition = playerDetectionZone.getPlayerPosition()
		look_at(playerPosition)
		if enemyGun != null and enemyGun.canFire():
			enemyGun.fire(playerPosition)
	
func spawnEnemyGun():
	enemyGun = EnemyGun.instance()
	add_child(enemyGun)
	enemyGun.global_position = global_position
	enemyGun.rotation = rotation
	enemyGun.setMask(3)
