extends CharacterBody2D

@export var dialogue_lines: Array[String] = ["Hello!", "How can I help you?", "Goodbye!"]
@export var next_scene_path: String = ""  # Path to the next scene, leave empty if none
var player_proximity: bool = false

# Called when the player enters the Area2D
func _on_Area2D_body_entered(body: Node) -> void:
	if body.name == "Player2D":
		player_proximity = true
		print("Player in range")

# Called when the player exits the Area2D
func _on_Area2D_body_exited(body: Node) -> void:
	if body.name == "Player2D":
		player_proximity = false
		print("Player out of range")

# Handle interaction with the player
func _process(delta: float) -> void:
	if player_proximity and Input.is_action_just_pressed("interact"):
		trigger_dialogue()

# Function to trigger the dialogue box
func trigger_dialogue() -> void:
	print("Triggering dialogue...")

	# Instantiate the dialogue box scene
	var dialogue_box = preload("res://scenes/dialogue.tscn").instantiate()
	print("Passing dialogue lines to dialogue box:", dialogue_lines)
	# Pass dialogue lines and next scene path to the dialogue box
	dialogue_box.dialogue_lines = dialogue_lines
	dialogue_box.next_scene_path = next_scene_path

	# Add the dialogue box to the scene tree
	get_tree().root.add_child(dialogue_box)

	# Position the dialogue box above the NPC
	var npc_global_position = global_position
	dialogue_box.position = npc_global_position + Vector2(0, -150)  # Adjust the offset as needed

	print("Triggering dialogue...")
