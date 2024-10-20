extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var block = preload("res://scenes/block.tscn").instantiate()
	block.position = Vector2(869, 300)  # Set position as needed
	block.add_to_group("blocks")  # Add block to group for easy detection

	# Use Callable for the method connection
	block.connect("block_broken", Callable(self, "_on_block_broken"))  # Connect the signal here

	add_child(block)

func _on_block_broken() -> void:
	print("broken block")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
