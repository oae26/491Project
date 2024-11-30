extends Node

signal all_tasks_completed

@export var block_group: String = ""  # Group for blocks
@export var seed_group: String = ""   # Group for seeds
@export var door_path: NodePath       # Path to the door
@export var switch_path: NodePath     # Path to the switch

var seeds_grown = 0
var blocks_broken = 0
var connected_blocks = 0
var connected_seeds = 0

func _ready() -> void:
	print("TaskManager initialized for group:", block_group, "and", seed_group)

	# Connect all blocks in the group
	for block in get_tree().get_nodes_in_group(block_group):
		if block.has_signal("block_broken"):
			block.connect("block_broken", Callable(self, "_on_block_broken"))
			connected_blocks += 1
			print("Connected to block:", block.name, "in group:", block_group)

	# Connect all seeds in the group
	for seed in get_tree().get_nodes_in_group(seed_group):
		if seed.has_signal("seed_grown"):
			seed.connect("seed_grown", Callable(self, "_on_seed_grown"))
			connected_seeds += 1
			print("Connected to seed:", seed.name, "in group:", seed_group)

	# Debug output for total connections
	print("Total blocks connected in group", block_group, ":", connected_blocks)
	print("Total seeds connected in group", seed_group, ":", connected_seeds)

func _on_block_broken() -> void:
	blocks_broken += 1
	print("Block broken in group", block_group, ":", blocks_broken, "/", connected_blocks)
	check_tasks()

func _on_seed_grown() -> void:
	seeds_grown += 1
	print("Seed grown in group", seed_group, ":", seeds_grown, "/", connected_seeds)
	check_tasks()

func check_tasks() -> void:
	if seeds_grown == connected_seeds and blocks_broken == connected_blocks:
		print("All tasks completed for group", block_group, "and", seed_group)
		emit_signal("all_tasks_completed")
		reveal_switch()

func reveal_switch() -> void:
	var switch_node = get_node_or_null(switch_path)
	if switch_node:
		print("Revealing switch:", switch_node.name)
		switch_node.visible = true  # Make the switch visible
		switch_node.connect("switch_activated", Callable(self, "activate_door"))
	else:
		print("Error: Switch not found at path:", switch_path)

func activate_door() -> void:
	var door = get_node_or_null(door_path)
	if door:
		print("Activating door:", door.name, "for group:", block_group, "and", seed_group)
		door.open()
	else:
		print("Error: Door not found at path:", door_path)
