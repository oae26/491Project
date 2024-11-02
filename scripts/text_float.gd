extends Area2D

# Variables
@export var typing_speed: float = 0.01
@export var display_time: float = 1.5
@export var text_color: Color = Color(0, 0, 0)
@export var texts_to_display: Array[String] = [
	"What's the point anymore... everything is so cold...", 
	"Life is just too stifling...", 
	"Everything in my life is made harder by others. I just wish they would go away!", 
	"I'm.. I'm just really sad."
] 

# Zones as Position2D nodes
@export var zones: Array[Marker2D] = []

# Nodes
var label: Label
var typing_timer: Timer
var display_timer: Timer

# Variables for typewriter effect
var current_text: String = ""
var char_index: int = 0
var active_message_index: int = -1

func _ready():
	# Initialize the Label and Timers
	label = Label.new()
	label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	label.position = position
	label.visible = false  
	label.modulate = text_color
	add_child(label)
	
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

	body_entered.connect(_on_Area2D_body_entered)

# Triggered when player enters the main Area2D
func _on_Area2D_body_entered(body: Node):
	if body.name == "Player":
		# Find the closest zone to the player’s position
		active_message_index = _get_closest_zone_index(body.global_position)
		if active_message_index != -1:
			current_text = texts_to_display[active_message_index]
			label.text = ""
			char_index = 0
			label.visible = true
			typing_timer.start()

# Returns the index of the closest zone based on player's position
func _get_closest_zone_index(player_position: Vector2) -> int:
	var closest_index = -1
	var min_distance = INF
	for i in range(zones.size()):
		var distance = player_position.distance_to(zones[i].global_position)
		if distance < min_distance:
			min_distance = distance
			closest_index = i
	return closest_index

# Typewriter effect
func _on_TypingTimer_timeout():
	if char_index < current_text.length():
		label.text += current_text[char_index]
		char_index += 1
		typing_timer.start()
	else:
		display_timer.start()

# Make text fade after display time
func _on_DisplayTimer_timeout():
	var tween = get_tree().create_tween()
	tween.tween_property(label, "modulate:a", 0.0, 1.0)
	await tween.finished
	label.visible = false
	label.modulate.a = 1.0
