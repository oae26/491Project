# SceneSwitch.gd
extends Node

@export var default_scene: String

# Function to change to a specified scene
func change_scene(scene_path: String) -> void:
	get_tree().change_scene(scene_path)

# Function to load a scene dynamically
func load_scene(scene_path: String) -> void:
	var scene = ResourceLoader.load(scene_path) as PackedScene
	if scene:
		var new_scene = scene.instantiate()
		get_tree().current_scene.queue_free()
		get_tree().root.add_child(new_scene)
		get_tree().current_scene = new_scene
	else:
		print("Error: Could not load scene: " + scene_path)
