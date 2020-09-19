extends Node


# Dictionaries for movement - key:value - physicsFrame:inputStrength
var moveRight = {}
var moveLeft = {}
var moveUp = {}
var moveDown = {}

var physicsFrame = 0
var start = false
var movementSet = false


# Called when the node enters the scene tree for the first time.
func _ready():
	physicsFrame = 0

func _physics_process(delta):
	if start:
		physicsFrame += 1
		
func start_replaying():
	start = true
		
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
	
# Set the dictionaries for movement inputs
func set_movement_dicts(right, left, up, down):
	if !movementSet:
		moveRight = right
		moveLeft = left
		moveUp = up
		moveDown = down
		
		movementSet = true
	
