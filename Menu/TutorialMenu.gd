extends Node2D

onready var logoAnimation = $LogoAnimationPlayer
onready var lmb = $LMB
onready var e = $E
onready var f = $F
onready var wasd = $WASD
onready var holo = $Holo
onready var label = $CanvasLayer/Label

func _ready():
	VisualServer.set_default_clear_color(Color("#238531"))
	e.visible = true
	f.visible = true
	wasd.visible = true
	holo.visible = false
	label.visible = false

func _on_Button_pressed():
	get_tree().change_scene("res://Menu/TitleMenu.tscn")


func _on_Next_pressed():
	e.visible = not e.visible
	f.visible = not f.visible
	wasd.visible = not wasd.visible
	holo.visible = not holo.visible
	label.visible = not label.visible
	
