extends Node2D


onready var spawnPoint = $SpawnPoint
onready var player = $Player
onready var recorder = player.get_node("Recorder")
onready var hologram = preload("res://HologramPlayer/HologramPlayer.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	recorder.connect("player_death", self, "_on_player_death")
	player.position = spawnPoint.position

func _on_player_death(right, left, up, down, shots, drops):
	var holo = hologram.instance()
	self.add_child(holo)
	holo.get_node("Replayer").set_movement_dicts(right, left, up, down)
	holo.get_node("Replayer").set_shot_dict(shots)
	holo.get_node("Replayer").set_drop_dict(drops)
	holo.position = spawnPoint.position
	holo.get_node("Replayer").start_replaying()
	
