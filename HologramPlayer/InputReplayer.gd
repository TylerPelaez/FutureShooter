extends Node


# Dictionaries for movement - key:value - physicsFrame:inputStrength
var moveRight = {}
var moveLeft = {}
var moveUp = {}
var moveDown = {}

# Dictionary for gun dropped and thrown - key:value - physicsFrame:bool
var gunDropped = {}
var gunThrown = {}

# Dictionary for shots fired - key:value - physicsFrame:mousePos
var shotsDict = {}

var physicsFrame = 0
var start = false
var movementSet = false
var shotsSet = false
var dropSet = false
var throwSet = false


# Called when the node enters the scene tree for the first time.
func _ready():
	physicsFrame = 0

func _physics_process(delta):
	if start:
		physicsFrame += 1
		
func start_replaying():
	start = true
	
func reset():
	moveRight = {}
	moveLeft = {}
	moveUp = {}
	moveDown = {}
	shotsDict = {}
	gunDropped = {}
	gunThrown = {}
	physicsFrame = 0
	start = false;
	movementSet = false
	shotsSet = false
	dropSet = false
	throwSet = false
		
func get_input_vector():
	var input_vector = Vector2.ZERO
	
	# Check for any WASD input on this physics frame
	var right = 0
	var left = 0
	var up = 0 
	var down = 0
	if moveRight.has(physicsFrame):
		right = moveRight[physicsFrame]
	if moveLeft.has(physicsFrame):
		left = moveLeft[physicsFrame]
	if moveUp.has(physicsFrame):
		up = moveUp[physicsFrame]
	if moveDown.has(physicsFrame):
		down = moveDown[physicsFrame]

	input_vector.x = right - left
	input_vector.y = down - up
	input_vector = input_vector.normalized()
	return input_vector
	
func get_shots_fired():
	# Check if a shot was fired on this physics frame and return mousePos at the time
	if shotsDict.has(physicsFrame):
		return shotsDict[physicsFrame]
	return false
	
func get_gun_dropped():
	# Check if the gun was dropped on this physics frame and return true/false
	if gunDropped.has(physicsFrame):
		return gunDropped[physicsFrame]
	return false
	
func get_gun_thrown():
	# Check if the gun was thrown on this physics frame and return mousePos
	if gunThrown.has(physicsFrame):
		return gunThrown[physicsFrame]
	return false
	
# Sets dictionary of shots
func set_shot_dict(shots):	
	if !shotsSet:
		shotsDict = shots
		
	shotsSet = true
	
# Set the dictionaries for movement inputs
func set_movement_dicts(right, left, up, down):
	if !movementSet:
		moveRight = right
		moveLeft = left
		moveUp = up
		moveDown = down
		
		movementSet = true
	
# Set gun dropped dictionary	
func set_drop_dict(dropped):
	if !dropSet:
		gunDropped = dropped
		
	dropSet = true
	
# Set gun thrown dictionary
func set_throw_dict(thrown):
	if !throwSet:
		gunThrown = thrown
	
	throwSet = true
