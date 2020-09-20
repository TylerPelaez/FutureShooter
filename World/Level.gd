extends Node2D

const HologramPlayer = preload("res://HologramPlayer/HologramPlayer.tscn")
const Player = preload("res://Player/Player.tscn")
const EnemyClass = preload("res://Enemies/Enemy.gd")
const StationaryEnemyClass = preload("res://Enemies/StationaryEnemy.gd")

enum WIN_CONDITION {
	KILL_ALL
}

export var levelBackgroundColor := "#57142e"
export (WIN_CONDITION) var winCondition = WIN_CONDITION.KILL_ALL


enum {
	RIGHT,
	LEFT,
	UP,
	DOWN,
	SHOTS,
	DROPS,
	THROWS,
	ROTATIONS
}

onready var spawnPoint = $SpawnPoint
onready var camera = $Camera
onready var victoryTimer = $VictoryTimer

var player = null
var recorder = null
var enemies = []
var playerDied = false

# Called when the node enters the scene tree for the first time.
func _ready():
	VisualServer.set_default_clear_color(Color(levelBackgroundColor))
	
	if winCondition == WIN_CONDITION.KILL_ALL:
		for child in get_children():
			if child is EnemyClass or child is StationaryEnemyClass:
				enemies.append(child)
				child.connect("enemy_died", self, "_on_Enemy_died")
	
	spawnPlayer()
	
	if !PersistentRecordedInput.get_state().empty():
		spawnHologram(PersistentRecordedInput.get_state())
		PersistentRecordedInput.clear_state()

func _on_player_death(right, left, up, down, shots, drops, throws, rotations):
	playerDied = true
	restartScene(right,left,up,down,shots,drops,throws,rotations)

func restartScene(right, left, up, down, shots, drops, throws, rotations):
	var newState = {
		RIGHT: right,
		LEFT: left,
		UP: up,
		DOWN: down,
		SHOTS: shots,
		DROPS: drops,
		THROWS: throws,
		ROTATIONS: rotations
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
	var rotations = state[ROTATIONS]
	
	var holo = HologramPlayer.instance()
	self.add_child(holo)
	var replayer = holo.get_node("Replayer")
	
	replayer.set_movement_dicts(right, left, up, down)
	replayer.set_shot_dict(shots)
	replayer.set_drop_dict(drops)
	replayer.set_throw_dict(throws)
	replayer.set_rotations(rotations)

	holo.global_position = spawnPoint.global_position
	replayer.start_replaying()

func winLevel():
	if not playerDied:
		get_tree().reload_current_scene()

func _on_Enemy_died(enemy):
	if winCondition == WIN_CONDITION.KILL_ALL:
		enemies.erase(enemy)
		if enemies.size() <= 0 and not playerDied:
			victoryTimer.start()



func _on_VictoryTimer_timeout():
	winLevel()
