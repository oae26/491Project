extends Control

@export var next_scene_path: String = ""  # Path to the next scene to load

@onready var color_rect = $ColorRect

@export var fade_duration: float = 1.0  # Duration for fade in/out transitions

# Set the initial state of the color rect
func _ready() -> void:
	color_rect.modulate = Color(0, 0, 0, 1)
	fade_in()

# Function to fade the screen in (from black to transparent)
func fade_in() -> void:
	var tween = get_tree().create_tween()
	tween.tween_property(color_rect, "modulate", Color(0, 0, 0, 0), fade_duration)

# Function to fade the screen out (from transparent to black)
func fade_out_and_change_scene() -> void:
	var tween = get_tree().create_tween()
	tween.tween_property(color_rect, "modulate", Color(0, 0, 0, 1), fade_duration)
	tween.tween_callback(Callable(self, "_change_scene"))

# Callback to change the scene after fading out
func _change_scene() -> void:
	if next_scene_path != "":
		get_tree().change_scene_to_file(next_scene_path)
		queue_free()
	else:
		queue_free()  # If no scene specified, simply remove the node
