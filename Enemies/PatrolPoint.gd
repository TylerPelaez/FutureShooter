extends Position2D

signal patrol_ended()

onready var pointTimer = $PointTimer

func startPatrol():
	pointTimer.start()

func stopPatrol():
	pointTimer.stop()

func _on_PointTimer_timeout():
	emit_signal("patrol_ended")
