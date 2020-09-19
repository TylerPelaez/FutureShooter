extends "res://Enemies/Enemy.gd"

const EnemyGun = preload("res://Guns/PlayerGun.tscn")

var detectedPlayer = false
onready var player = get_parent().get_node("Player")
var enemyGun = null

func _ready():
	spawnEnemyGun()

func _physics_process(delta):
	if detectedPlayer:
		look_at(player.global_position)
	
func spawnEnemyGun():
	enemyGun = EnemyGun.instance()
	add_child(enemyGun)
	enemyGun.global_position = global_position
	enemyGun.rotation = rotation
	enemyGun.setMask(3)

func _on_PlayerDetectionZone_body_entered(body):
	detectedPlayer = true

func _on_PlayerDetectionZone_body_exited(body):
	detectedPlayer = false
