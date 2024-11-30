extends CharacterBody2D

enum ControlState { PLAYER, SPORE }
var last_anchor: Node2D = null  # Stores the last activated anchor point
const SPEED = 300.0
const JUMP_VELOCITY = -400.0
var screen_size
var control_state: ControlState = ControlState.PLAYER
var spore_count: int = 0
var current_spore: Node = null
var current_block: Node = null
var npc: Node = null  # Variable to track NPC in range
const aoE = preload("res://scenes/grow_aoe.tscn")
@onready var player_manager = get_parent()
@onready var game = get_tree().root.get_node("IceLevel")
@onready var SPORE = load("res://scenes/spore.tscn")
@onready var area2d = $Player2D
@onready var npc_area2d = $NPCInteractionArea
@onready var footsteps = $AudioStreamPlayer
var time_off_ground: float = 0.0  # Tracks how long the player has been off the ground
@export var fall_time_threshold: float = 1.0  # Time (in seconds) to consider the player as falling
var is_in_transition: bool = false  # Tracks if the player is in a transition zone
@export var flowers: Array = [
	{
		"texture": preload("res://art/Daffodil.png"),
		"message": "A new mindset begins to take root..."
	},
	{
		"texture": preload("res://art/Rose.png"),
		"message": "A new mindset begins to take root..."
	},
	{
		"texture": preload("res://art/Cosmo.png"),
		"message": "A new mindset begins to take root..."
	},
	{
		"texture": preload("res://art/LilyOfTheValley.png"),
		"message": "A new mindset begins to take root..."
	}
]


# Track the last movement direction (-1 for left, 1 for right)
var last_direction = 1

func _ready() -> void:

	print("Footsteps node:", footsteps)
	# Check for the Player2D node before trying to use it
	if has_node("Player2D"):
		area2d = $Player2D
		print("2DArea is accepted!")
		if area2d.has_signal("body_entered"):
			area2d.body_entered.connect(_on_Area2D_body_entered)
		if area2d.has_signal("body_exited"):
			area2d.body_exited.connect(_on_Area2D_body_exited)
	else:
		print("Player2D node not found in this scene")

	# Check for the NPCInteractionArea node
	if has_node("NPCInteractionArea"):
		npc_area2d = $NPCInteractionArea
		if npc_area2d.has_signal("body_entered"):
			npc_area2d.body_entered.connect(_on_NPCInteractionArea_body_entered)
		if npc_area2d.has_signal("body_exited"):
			npc_area2d.body_exited.connect(_on_NPCInteractionArea_body_exited)
	else:
		print("NPCInteractionArea not found in this scene")

func _physics_process(delta: float) -> void:
	if is_on_floor():
		time_off_ground = 0.0  # Reset timer when on the ground
	elif not is_in_transition:
		time_off_ground += delta  # Increment timer only if not in transition

	if time_off_ground > fall_time_threshold and not is_in_transition:
		respawn()
		# Add gravity
	if not is_on_floor():
		velocity += get_gravity() * delta
	

	if control_state == ControlState.PLAYER:
		# Handle jump
		if Input.is_action_just_pressed("ui_accept") and is_on_floor():
			velocity.y = JUMP_VELOCITY

	# Get the input direction and handle movement/deceleration
		var direction := Input.get_axis("move_left", "move_right")
		if direction != 0:
			velocity.x = direction * SPEED
			$AnimatedSprite2D.animation = "walk"
			$AnimatedSprite2D.play()
			if not footsteps.is_playing() and is_on_floor():
				footsteps.play()
		
			last_direction = sign(direction)
			$AnimatedSprite2D.flip_h = (last_direction == -1)
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
			$AnimatedSprite2D.stop()
			$AnimatedSprite2D.flip_h = (last_direction == -1)
			if footsteps.is_playing() and not is_on_floor():
				footsteps.stop()
		# Block breaking
		if Input.is_action_just_pressed("break_block") and current_block:
			print("Breaking Block")
			current_block.destroy_block()
			
		# Spore launching
		if Input.is_action_just_pressed("spore_launch"):
				launch_spore()

		# NPC interaction
		if Input.is_action_just_pressed("interact") and npc:
			trigger_dialogue(npc)
	elif control_state == ControlState.SPORE:
		velocity = Vector2.ZERO
		
	move_and_slide()
	
	if 	Input.is_action_just_released("grow_aoe"):
		print("growing")
		_grow();
# Function to trigger dialogue with the NPC
func trigger_dialogue(npc_node: Node) -> void:
	var dialogue_box = preload("res://scenes/dialogue.tscn").instantiate()
	get_tree().root.add_child(dialogue_box)
	dialogue_box.dialogue_lines = npc_node.dialogue_lines
	print("Dialogue triggered with NPC")

# Area2D signals for blocks
func _on_Area2D_body_entered(body: Node) -> void:
	if body.is_in_group("blocks"):
		current_block = body
		var callable_on_block_destroyed = Callable(self, "_on_block_destroyed")
		if not current_block.is_connected("block_broken", callable_on_block_destroyed):
			current_block.connect("block_broken", callable_on_block_destroyed)

func _on_Area2D_body_exited(body: Node) -> void:
	if body == current_block:
		current_block = null

# Area2D signals for NPCs
func _on_NPCInteractionArea_body_entered(body: Node) -> void:
	if body.has_method("trigger_dialogue"):
		npc = body
		print("Player entered NPC interaction area")

func _on_NPCInteractionArea_body_exited(body: Node) -> void:
	if body == npc:
		npc = null
		print("Player exited NPC interaction area")

# Function to launch a spore
func launch_spore() -> void:
	# Checks to see if a spore is already present
	if spore_count == 0:
		var spore = SPORE.instantiate()
		current_spore = spore
		spore_count = 1
		spore.dir = rotation
		spore.spawnPos = global_position
		spore.spawnRot = rotation
		game.add_child(spore)
		print("Spore is launched. Spore count: ", spore_count)
		# Resets spore count to zero if spore has been destroyed
		spore.connect("tree_exited", Callable(self, "destroy_spore"))
		# Pass control to spore
		print("Controlling spore")
		control_state = ControlState.SPORE
	else:
		print("Spore already exists")

func destroy_spore() -> void:
	print("Spore has been destroyed")
	spore_count = 0
	current_spore = null
	control_state = ControlState.PLAYER
	print("Controlling player")
	
func _on_block_destroyed() -> void:
	if not current_block:
		return
	
	var block_position = current_block.global_position
	
	# Trigger a thought or memory UI
	var thought_ui_scene = preload("res://scenes/thought_UI.tscn")
	var thought_ui_instance = thought_ui_scene.instantiate()
	
	var random_flower = flowers[randi() % flowers.size()]
	
	# Create a new Sprite2D node for the flower
	var flower_sprite = Sprite2D.new()
	flower_sprite.texture = random_flower["texture"]
	flower_sprite.position = block_position
	
	# Add the flower to the scene
	get_tree().get_current_scene().add_child(flower_sprite)
	
	# Display the associated message as a thought UI
	show_flower_message(block_position, random_flower["message"])

	# Assuming ThoughtUI scene has a `set_text` method

	# Add ThoughtUI to the current scene
	get_tree().get_current_scene().add_child(thought_ui_instance)

	# Reset the current block reference
	current_block = null
	
func show_flower_message(position: Vector2, message: String) -> void:
	var label = Label.new()
	label.text = message
	label.position = position + Vector2(0, -50)  # Position above the flower
	get_tree().get_current_scene().add_child(label)

	# Fade out and remove the label
	label.modulate = Color(1, 1, 1, 1)  # Fully opaque
	var timer = get_tree().create_timer(3.0)  # Create a timer for 3 seconds
	timer.timeout.connect(func():
		label.queue_free()  # Remove the label when the timer ends
	)
func _grow():
	var grow = aoE.instantiate();

	get_parent().add_child(grow);
	grow.position = global_position;
func respawn() -> void:
	if last_anchor:
		global_position = last_anchor.respawn_position
		velocity = Vector2.ZERO  # Reset velocity
		print("Respawned at anchor:", last_anchor.name)
	else:
		print("No anchor set! Respawning at default start position.")
		global_position = Vector2.ZERO  # Default spawn position

	time_off_ground = 0.0  # Reset the timer after respawning
