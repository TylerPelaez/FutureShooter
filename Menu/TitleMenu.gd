extends Node2D

func _ready():
	VisualServer.set_default_clear_color(Color("#238531"))


func _on_Button_pressed():
	get_tree().change_scene(Utils.get_scene(1))
