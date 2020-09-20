extends KinematicBody2D

signal enemy_died(enemy)
onready var stats = $EnemyStats

func _on_Hurtbox_hit(damage):
	stats.health -= damage

func _on_EnemyStats_enemy_died():
	emit_signal("enemy_died", self)
	queue_free()
