extends Control

@export var text: String = "Default thought"  # Customizable thought text
@export var duration: float = 3.0  # How long the UI stays visible

@onready var label = $Label  # Reference to the Label
@onready var animation_player = $AnimationPlayer  # Optional AnimationPlayer

func _ready() -> void:
	# Set the Label's text
	if not label:
		print("Error: Label node is missing!")
		return  # Stop further execution to prevent errors
	# If the label exists, set the text
	label.text = text
	await(get_tree().create_timer(duration))
	queue_free()
func set_text(new_text: String) -> void:
	label.text = new_text
