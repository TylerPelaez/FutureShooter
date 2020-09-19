extends KinematicBody2D

onready var stats = $EnemyStats

func _on_Hurtbox_hit(damage):
	stats.health -= damage

func _on_EnemyStats_enemy_died():
	queue_free()
