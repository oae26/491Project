extends CanvasLayer

@export var dialogue_lines: Array[String] = []
@export var next_scene_path: String = "res://scenes/Game.tscn"

var label: Label
var current_index = 0

# Initialize dialogue display
func _ready() -> void:
	# Dynamically assign the label node
	label = $DialogueControl/DialogueLabel

	# Check if the label was found
	if label == null:
		print("Error: DialogueLabel not found!")
		return

	# Display the first line of dialogue if available
	if dialogue_lines.size() > 0:
		label.text = dialogue_lines[current_index]
	else:
		label.text = "No dialogue lines provided."

# Handle advancing dialogue with the interact key
func _process(delta: float) -> void:
	if label == null:
		return  # Ensure label exists before updating text

	if Input.is_action_just_pressed("ui_accept"):
		current_index += 1
		if current_index < dialogue_lines.size():
			label.text = dialogue_lines[current_index]
		else:
			end_dialogue()

# End the dialogue and change scene if needed
func end_dialogue() -> void:
	if next_scene_path != "":
		get_tree().change_scene_to_file(next_scene_path)
	else:
		queue_free()  # Close the dialogue box
