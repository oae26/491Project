extends StaticBody2D

signal seed_grown

@export var seed_type: String = "platform"  # Type of seed: "platform" or "jump"
const platform = preload("res://scenes/platform.tscn")

var grown: bool = false
var platform_to_spawn: Node2D = null  # Tracks the platform to spawn in the next frame

func _ready() -> void:
	# Add the seed to the appropriate group
	if seed_type == "platform":
		add_to_group("platform_seeds")
	elif seed_type == "jump":
		add_to_group("jump_seeds")
	elif seed_type == "final":
		add_to_group("final_seed")
	else:
		print("Unknown seed type:", seed_type)

func _physics_process(delta: float) -> void:
	# Check if there's a pending platform to spawn
	if platform_to_spawn:
		spawn_platform(platform_to_spawn)
		platform_to_spawn = null  # Clear after spawning

func grow_seed() -> void:
	if grown:
		return  # Prevent multiple growths

	grown = true
	emit_signal("seed_grown")  # Emit the signal before destroying the seed

	if seed_type == "platform":
		boost_player_and_prepare_platform()
	elif seed_type == "jump":
		boost_player_only()
	elif seed_type == "final":
		emit_signal("final_seed_grown")  # Emit a special signal for the final seed
		print("Final seed grown.")
		get_tree().change_scene_to_file("res://scenes/ice_level_cured.tscn")

	else:
		print("Seed grown:", name)

	queue_free()  # Remove the seed after use

func boost_player_and_prepare_platform() -> void:
	# Get the player node
	var player = get_tree().get_current_scene().get_node("Player")
	if not player:
		print("Player not found!")
		return

	# Boost the player upward
	player.velocity.y = player.JUMP_VELOCITY
	print("Player boosted upward.")

	# Prepare the platform for spawning in the next frame
	platform_to_spawn = player

func boost_player_only() -> void:
	# Boost the player without spawning a platform
	var player = get_tree().get_current_scene().get_node("Player")
	if player:
		player.velocity.y = player.JUMP_VELOCITY
		print("Player boosted with jump seed.")

func spawn_platform(player: CharacterBody2D) -> void:
	# Instantiate and place the platform relative to the player's position
	var plat = platform.instantiate()
	get_parent().add_child(plat)

	# Find the player's collision shape to calculate its bottom
	var collision_shape = player.get_node("CollisionShape2D")  # Replace with the correct path to your collision shape
	if not collision_shape:
		print("Player's CollisionShape2D not found!")
		return

	# Handle different shape types
	var shape = collision_shape.shape
	var player_bottom_y = player.global_position.y

	if shape is CircleShape2D:
		player_bottom_y += shape.radius + 10  # Add the radius and an offset below the player
	elif shape is RectangleShape2D:
		player_bottom_y += shape.extents.y + 10  # Add the extents and an offset

	plat.global_position = Vector2(player.global_position.x, player_bottom_y + 150)

	print("Platform spawned below player at:", plat.global_position)
