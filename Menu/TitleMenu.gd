extends Node2D

onready var logoAnimation = $LogoAnimationPlayer

func _ready():
	VisualServer.set_default_clear_color(Color("#238531"))
	logoAnimation.play("LogoFlash")

func _on_Button_pressed():
	get_tree().change_scene(Utils.get_scene(1))
