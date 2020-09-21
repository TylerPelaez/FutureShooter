extends Node2D

const HologramPlayer = preload("res://HologramPlayer/HologramPlayer.tscn")
const Player = preload("res://Player/Player.tscn")
const EnemyClass = preload("res://Enemies/Enemy.gd")
const StationaryEnemyClass = preload("res://Enemies/StationaryEnemy.gd")

enum WIN_CONDITION {
	KILL_ALL
}


export var levelBackgroundColor := "#973f3f"
export (WIN_CONDITION) var winCondition = WIN_CONDITION.KILL_ALL
export var SPAWN_PLAYER_WITH_GUN := false
export var LEVEL_NUMBER := 0

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
onready var resetChoice = $CanvasLayer/ResetChoice
onready var clearButton = $CanvasLayer/ResetChoice/ClearButton
onready var keepButton = $CanvasLayer/ResetChoice/KeepButton
onready var tilemap = $TileMap

var player = null
var recorder = null
var enemies = []
var playerDied = false

signal de_sync

# Called when the node enters the scene tree for the first time.
func _ready():
	VisualServer.set_default_clear_color(Color(levelBackgroundColor))
	
	for N in self.get_children():
		self.connect("de_sync", N, "_on_de_sync")
	
	if winCondition == WIN_CONDITION.KILL_ALL:
		for child in get_children():
			if child is EnemyClass or child is StationaryEnemyClass:
				enemies.append(child)
				child.connect("enemy_died", self, "_on_Enemy_died")
	
	spawnPlayer()
	
	if !PersistentRecordedInput.get_state().empty():
		var cells = tilemap.get_used_cells()
		for cell in  cells:
			var tileIndex = tilemap.get_cellv(cell)
			var autoTileCoord = tilemap.get_cell_autotile_coord(cell.x, cell.y)
			var is_x_flipped = tilemap.is_cell_x_flipped(cell.x, cell.y)
			var is_y_flipped = tilemap.is_cell_y_flipped(cell.x, cell.y)
			var is_cell_transposed = tilemap.is_cell_transposed(cell.x, cell.y)
			
			tilemap.set_cell(cell.x, cell.y, 1, is_x_flipped, is_y_flipped, is_cell_transposed, autoTileCoord)
			
		emit_signal("de_sync")
			
		spawnHologram(PersistentRecordedInput.get_state())
		PersistentRecordedInput.clear_state()

func _on_player_death(right, left, up, down, shots, drops, throws, rotations):
	playerDied = true
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
	
	resetChoice.visible = true
	clearButton.disabled = false
	keepButton.disabled = false

func restartScene():
	get_tree().reload_current_scene()

func spawnPlayer():
	player = Player.instance()
	player.SPAWN_WITH_GUN = SPAWN_PLAYER_WITH_GUN
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
	holo.SPAWN_WITH_GUN = SPAWN_PLAYER_WITH_GUN
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
		get_tree().change_scene(Utils.get_scene(LEVEL_NUMBER + 1))

func _on_Enemy_died(enemy):
	if winCondition == WIN_CONDITION.KILL_ALL:
		enemies.erase(enemy)
		if enemies.size() <= 0 and not playerDied:
			victoryTimer.start()


func _on_VictoryTimer_timeout():
	winLevel()


func _on_ClearButton_pressed():
	PersistentRecordedInput.clear_state()
	restartScene()


func _on_KeepButton_pressed():
	restartScene()
