extends Control

@export var dialogue_lines: Array[String] = []
@export var next_scene_path: String = ""

var label: Label
var current_index: int = 0

# Initialize dialogue display
func _ready() -> void:
	print(dialogue_lines)  # Ensure dialogue_lines are received properly
	label = $DialogueControl/DialogueLabel
	set_process_input(true)  # Ensure the dialogue box receives input focus
	grab_focus()  # Ensure the dialogue box captures input exclusively

	if label == null:
		print("Error: DialogueLabel not found!")
		return
	
	if dialogue_lines.size() > 0:
		label.text = dialogue_lines[current_index]  # Display the first line
	else:
		label.text = "No dialogue lines provided."

# Handle advancing dialogue with the interact key
func _process(delta: float) -> void:
	if label == null:
		return  # Ensure label exists before updating text

	# Handle advancing the dialogue
	if Input.is_action_just_pressed("ui_accept"):
		current_index += 1
		if current_index < dialogue_lines.size():
			label.text = dialogue_lines[current_index]
		else:
			end_dialogue()

# End the dialogue and change scene if needed
func end_dialogue() -> void:
	print("Ending dialogue...")
	set_process_input(false)  # Disable further input processing for this dialogue box
	queue_free()
	var transition = preload("res://scenes/transition.tscn").instantiate()
	get_tree().root.add_child(transition)
	get_tree().change_scene_to_file(next_scene_path)

	queue_free()
