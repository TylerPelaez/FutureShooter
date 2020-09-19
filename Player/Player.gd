extends KinematicBody2D

const PlayerGun = preload("res://Guns/PlayerGun.tscn")

export var ACCELERATION := 500
export var MAX_SPEED := 100
export var FRICTION := 500
export var AIM_SPEED := 1

enum {
	MOVE,
	ATTACK
}

var velocity = Vector2.ZERO
var state = MOVE
var playerGun

# TODO: Don't instantiate the gun on init
func _ready():
	playerGun = PlayerGun.instance()
	add_child(playerGun)
	playerGun.global_position = global_position
	playerGun.rotation = rotation

func _physics_process(delta):
	match state:
		MOVE:
			move_state(delta)
	
	faceMouse()
	
	if Input.is_action_pressed("fire") and playerGun.canFire():
		playerGun.fire(get_global_mouse_position())


func move_state(delta):
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	input_vector = input_vector.normalized()
	
	if input_vector != Vector2.ZERO:
		velocity = velocity.move_toward(input_vector * MAX_SPEED, ACCELERATION * delta)
	else:
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
	
	move()
	
func move():
	velocity = move_and_slide(velocity)

func faceMouse():
	var mousePosition = get_global_mouse_position()	
	look_at(mousePosition)
