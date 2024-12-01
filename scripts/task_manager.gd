extends Node

signal all_tasks_completed

@export var block_group: String = ""  # Group for blocks (e.g., blocks_top or blocks_bottom)
@export var seed_group: String = ""   # Group for seeds (e.g., seeds_top or seeds_bottom)
@export var door_path: NodePath       # Path to the door
@export var switch_path: NodePath     # Path to the switch
@export var final_seed_path: NodePath  # Path to the final seed
@export var final_scene_path: String  # Path to the final scene file
var seeds_grown = 0
var blocks_broken = 0
var connected_blocks = 0
var connected_platform_seeds = 0

func _ready() -> void:
	print("TaskManager initialized for groups:", block_group, seed_group)

	# Connect all blocks in the specified block group
	for block in get_tree().get_nodes_in_group(block_group):
		if block.has_signal("block_broken"):
			block.connect("block_broken", Callable(self, "_on_block_broken"))
			connected_blocks += 1
			print("Connected to block:", block.name, "in group:", block_group)

	# Connect all platform seeds in the specified seed group
	for seed in get_tree().get_nodes_in_group(seed_group):
		if seed.has_signal("seed_grown") and seed.is_in_group("platform_seeds"):
			seed.connect("seed_grown", Callable(self, "_on_seed_grown"))
			connected_platform_seeds += 1
			print("Connected to platform seed:", seed.name, "in group:", seed_group)

	# Debug output for total connections
	print("Total blocks connected in group", block_group, ":", connected_blocks)
	print("Total platform seeds connected in group", seed_group, ":", connected_platform_seeds)

func _on_block_broken() -> void:
	blocks_broken += 1
	print("Block broken in group", block_group, ":", blocks_broken, "/", connected_blocks)
	check_tasks()

func _on_seed_grown() -> void:
	seeds_grown += 1
	print("Platform seed grown in group", seed_group, ":", seeds_grown, "/", connected_platform_seeds)
	check_tasks()

func check_tasks() -> void:
	if seeds_grown == connected_platform_seeds and blocks_broken == connected_blocks:
		print("All tasks completed for groups:", block_group, seed_group)
		emit_signal("all_tasks_completed")
		reveal_switch()

func reveal_switch() -> void:
	var switch_node = get_node_or_null(switch_path)
	if switch_node:
		print("Revealing switch:", switch_node.name)
		switch_node.visible = true
		switch_node.connect("switch_activated", Callable(self, "activate_door"))
	else:
		print("Switch not found at path:", switch_path)

func activate_door() -> void:
	var door = get_node_or_null(door_path)
	if door:
		print("Activating door:", door.name, "for groups:", block_group, seed_group)
		door.open()
	else:
		print("Door not found at path:", door_path)
		
func reveal_final_seed() -> void:
	var final_seed = get_node_or_null(final_seed_path)
	if final_seed:
		final_seed.visible = true
		print("Final seed revealed!")
		final_seed.connect("seed_grown", Callable(self, "_on_final_seed_grown"))  # Connect final seed's grown signal
	else:
		print("Final seed not found!")

func _on_final_seed_grown() -> void:
	print("Final seed grown! Transitioning to the last scene.")
	load_final_scene()

func load_final_scene() -> void:
	if final_scene_path == null:
		print("Error: Final scene path is not set.")
		return
	
	var final_scene = load(final_scene_path)
	if final_scene:
		var final_scene_instance = final_scene.instantiate()
		get_tree().root.add_child(final_scene_instance)
		print("Final scene loaded.")
		get_tree().current_scene.queue_free()  # Optionally unload the current scene
	else:
		print("Error: Failed to load final scene at path:", final_scene_path)
