extends Node
#Singleton!

func instance_scene_on_main(scene, position):
	var main = get_tree().current_scene
	var instance = scene.instance()
	main.add_child(instance)
	instance.global_position = position
	return instance

func get_scene(sceneNumber):
	return "res://World/Level" + str(sceneNumber) + ".tscn"
