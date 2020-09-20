extends Node2D

func _ready():
	VisualServer.set_default_clear_color(Color("#6c349d"))


func _on_Button_pressed():
	get_tree().change_scene(Utils.get_scene(1))
