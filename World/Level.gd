extends Node2D

const HologramPlayer = preload("res://HologramPlayer/HologramPlayer.tscn")
const Player = preload("res://Player/Player.tscn")

enum {
	RIGHT,
	LEFT,
	UP,
	DOWN,
	SHOTS,
	DROPS,
	THROWS
}

onready var spawnPoint = $SpawnPoint
onready var camera = $Camera

var player = null
var recorder = null

# Called when the node enters the scene tree for the first time.
func _ready():
	# Give us a random seed every time
	randomize()
	spawnPlayer()
	
	if !PersistentRecordedInput.get_state().empty():
		spawnHologram(PersistentRecordedInput.get_state())
		PersistentRecordedInput.clear_state()

func _on_player_death(right, left, up, down, shots, drops, throws):
	var newState = {
		RIGHT: right,
		LEFT: left,
		UP: up,
		DOWN: down,
		SHOTS: shots,
		DROPS: drops,
		THROWS: throws
	}
	PersistentRecordedInput.set_state(newState)
	get_tree().reload_current_scene()


func spawnPlayer():
	player = Player.instance()
	self.add_child(player)
	player.global_position = spawnPoint.global_position
	player.setCameraFollow(camera)
	
	recorder = player.get_node("Recorder")
	recorder.connect("player_death", self, "_on_player_death")


func spawnHologram(state):
	# Forgive me master, just this once, I must go all out
	var right = state[RIGHT]
	var left = state[LEFT]
	var up = state[UP]
	var down = state[DOWN]
	var shots = state[SHOTS]
	var drops = state[DROPS]
	var throws = state[THROWS]
	
	var holo = HologramPlayer.instance()
	self.add_child(holo)
	holo.get_node("Replayer").set_movement_dicts(right, left, up, down)
	holo.get_node("Replayer").set_shot_dict(shots)
	holo.get_node("Replayer").set_drop_dict(drops)
	holo.get_node("Replayer").set_throw_dict(throws)
	holo.global_position = spawnPoint.global_position
	holo.get_node("Replayer").start_replaying()
