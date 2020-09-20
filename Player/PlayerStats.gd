extends Node

signal player_died

export var max_health := 1
onready var health = max_health setget set_health

func set_health(value):
	health = clamp(value, 0, max_health)
	if health <= 0:
		emit_signal("player_died")
