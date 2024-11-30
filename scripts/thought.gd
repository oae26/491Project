extends Control

@export var text: String = "Default thought"  # Customizable thought text
@export var duration: float = 3.0  # How long the UI stays visible

@onready var label = $Label  # Reference to the Label

func _ready() -> void:
	# Check if the label exists
	if not label:
		print("Error: Label node is missing!")
		return  # Prevent further execution

	# Set the text if the label is valid
	label.text = text
	
	# Start fade-out animation (if available) and remove after duration
	
	await(get_tree().create_timer(duration))
	queue_free()

func set_text(new_text: String) -> void:
	# Check if label is valid before setting text
	if not label:
		print("Error: Cannot set text. Label node is missing!")
		return
	label.text = new_text
