extends Area2D

# Variables
@export var typing_speed: float = 0.05 # Speed at which each character is typed
@export var display_time: float = 1.0 # Time text stays fully visible before vanishing
@export var text_color: Color = Color(0,0,0)
var text_to_display: String = "This is floating text!" # Default message

# Nodes
var label: Label
var typing_timer: Timer
var display_timer: Timer

# Variables for typewriter effect
var current_text: String = ""
var char_index: int = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	# Initialize the Label and Timers
	label = Label.new()
	label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	label.position = position + Vector2(100, 0) # Adjust floating position relative to the Area2D
	label.visible = false  # Initially invisible
	label.modulate = text_color
	add_child(label)
	
	#var dynamic_font = FontFile.new()
	#dynamic_font.size = 24;

	typing_timer = Timer.new()
	typing_timer.wait_time = typing_speed
	typing_timer.one_shot = true
	typing_timer.timeout.connect(_on_TypingTimer_timeout)
	add_child(typing_timer)

	display_timer = Timer.new()
	display_timer.wait_time = display_time
	display_timer.one_shot = true
	display_timer.timeout.connect(_on_DisplayTimer_timeout)
	add_child(display_timer)

	# Connect signal for when player enters the area
	body_entered.connect(_on_Area2D_body_entered)

# Trigger when player walks into the area
func _on_Area2D_body_entered(body: Node):
	if body.name == "Player":  # Change this to match your player's node name
		label.visible = true
		current_text = ""
		char_index = 0
		label.text = "" # Clear any previous text
		typing_timer.start() # Start the typewriter effect
		print("Label set to true")
		print("label visibile at position: ", label.position)

# Typewriter effect
func _on_TypingTimer_timeout():
	if char_index < text_to_display.length():
		current_text += text_to_display[char_index]
		label.text = current_text
		char_index += 1
		typing_timer.start() # Continue typing
	else:
		display_timer.start() # Start the timer to make the text disappear

# Make the text fade and disappear after it's been fully displayed
func _on_DisplayTimer_timeout():
	# Create a SceneTreeTween for the fade out animation
	var tween = get_tree().create_tween()
	tween.tween_property(label, "modulate:a", 0.0, 1.0)
	await tween.finished # Wait for the tween to finish
	label.visible = false
	label.modulate.a = 1.0  # Reset the alpha for the next time it's triggered
