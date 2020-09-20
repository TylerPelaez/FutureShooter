extends Node

signal new_patrol_point(newPoint)

const PatrolPoint = preload("res://Enemies/PatrolPoint.gd")

var points = []
var current_point = 0
var has_patrols = false
var stopped = false

func _ready():
	has_patrols = get_child_count() > 0
	
	for child in get_children():
		if child is PatrolPoint:
			points.append(child)
			child.connect("patrol_ended", self, "_on_patrol_ended")

func has_patrols():
	return has_patrols()

func start_patrol():
	if has_patrols:
		stopped = false
		var currentPoint = points[current_point]
		currentPoint.startPatrol()
		increment_current_point()
		return currentPoint.global_position
	
	return null

func stop_patrol():
	if has_patrols:
		stopped = true
		points[current_point].stopPatrol()
		increment_current_point()

func _on_patrol_ended():
	if !stopped:
		emit_signal("new_patrol_point", points[current_point].global_position)
		increment_current_point()
		points[current_point].startPatrol()

func increment_current_point():
	if current_point >= points.size() - 1:
		current_point = 0
	else:
		current_point += 1
