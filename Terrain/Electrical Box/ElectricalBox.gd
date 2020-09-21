extends StaticBody2D


onready var sprite = $Sprite


# Called when the node enters the scene tree for the first time.
func _ready():
	sprite.frame = 0


func _on_de_sync():
	sprite.frame = 1
