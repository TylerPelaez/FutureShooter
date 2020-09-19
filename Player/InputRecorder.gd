extends Node

# Dictionaries for movement - key:value - physicsFrame:inputStrength
var moveRight = {}
var moveLeft = {}
var moveUp = {}
var moveDown = {}

var physicsFrame = 0
var start = false


# Called when the node enters the scene tree for the first time.
func _ready():
	physicsFrame = 0

func _physics_process(delta):
	if start:
		physicsFrame += 1
		log_input()
		if Input.is_key_pressed(KEY_K):
			player_died()
	elif Input.is_key_pressed(KEY_R):
		start_recording()
	
func start_recording():
	start = true	
	print("RECORDING STARTED")
	
func reset():
	physicsFrame = 0
	moveRight.clear()
	moveLeft.clear()
	moveUp.clear()
	moveDown.clear()
	start = false
		
func log_input():
	# Check for WASD movement and log to corresponding dict
	var right = Input.get_action_strength("ui_right")
	var left = Input.get_action_strength("ui_left")
	var up = Input.get_action_strength("ui_up")
	var down = Input.get_action_strength("ui_down")

	if right:
		moveRight[physicsFrame] = right
	if left:
		moveLeft[physicsFrame] = left
	if up:
		moveUp[physicsFrame] = up
	if down:
		moveDown[physicsFrame] = down
		
# When the player dies, send the input data through a series of signals		
func player_died():
	emit_signal("player_death", moveRight, moveLeft, moveUp, moveDown)
	reset()
	
signal player_death(rightDict, leftDict, upDict, downDict)
