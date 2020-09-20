extends Node

# Dictionaries for movement - key:value - physicsFrame:inputStrength
var moveRight = {}
var moveLeft = {}
var moveUp = {}
var moveDown = {}

# Dictionary for dropping the gun - key:value - physicsFrame:bool
var gunDropped = {}

# Dictionary for firing and throwing the gun - key:value - physicsFrame:mousePos
var shootDirection = {}
var gunThrown = {}

var rotations = {}

var physicsFrame = 0
var start = false

# Called when the node enters the scene tree for the first time.
func _ready():
	physicsFrame = 0

func _physics_process(delta):
	if start:
		physicsFrame += 1
		log_input()
		log_drop()
		log_rotation()

func start_recording():
	start = true	

func reset():
	physicsFrame = 0
	moveRight = {}
	moveLeft = {}
	moveUp = {}
	moveDown = {}
	shootDirection = {}
	gunDropped = {}
	gunThrown = {}
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

# Called externally from Player.gd
func log_shot(mousePos):
	# Check if shot was fired and log mousePos at that moment
	if start:
		shootDirection[physicsFrame] = 	mousePos

func log_drop():
	# Check if gun was dropped during this physicsFrame, and log if so
	if Input.is_action_just_pressed("interact"):
		gunDropped[physicsFrame] = true

func log_throw(mousePos):
	# Check if gun was thrown during this physicsFrame, and log mousePos if so
	if start:
		gunThrown[physicsFrame] = mousePos

func log_rotation():
	rotations[physicsFrame] = get_parent().global_rotation

# When the player dies, send the input data through a series of signals		
func player_died():
	emit_signal("player_death", moveRight, moveLeft, moveUp, moveDown, shootDirection, gunDropped, gunThrown, rotations)
	reset()
	
signal player_death(rightDict, leftDict, upDict, downDict, shootDir, gunDrop, gunThrow, rotations)
