extends KinematicBody2D

onready var stats = $EnemyStats
onready var blood = load("res://Particles/EnemyBlood.tscn")
onready var deathAnimationPlayer = $deathAnimationPlayer

var dying = false

func _on_Hurtbox_hit(damage, pos, angle):
	var newBleed = blood.instance()
	add_child(newBleed)
	newBleed.global_position = pos
	newBleed.global_rotation = int(angle + (randi() % 2 - 1) + 180) % 360
	newBleed.restart()
	if !dying:
		stats.health -= damage

func _on_EnemyStats_enemy_died():
	dying = true
	var animationIndex = randi() % 2 + 1
	deathAnimationPlayer.play("DeathAnimation" + str(animationIndex))
	
func killEnemy():
	queue_free()

