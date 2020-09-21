extends AudioStreamPlayer2D

export(Array, AudioStream) var audio_files: Array

var one_shot = false

func _ready():
	randomize()
	
func _process(delta):
	if one_shot and not playing:
		queue_free()

func play_random():
	var random_index = randi() % audio_files.size()
	stop()
	stream = audio_files[random_index]
	play()
