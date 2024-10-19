extends StaticBody2D

signal block_broken
# Called when the node enters the scene tree for the first time.
var is_broken: bool = false
func _ready() -> void:
	add_to_group("blocks")  # Add this block to the "blocks" group
func destroy_block():
	if not is_broken:# Only allow breaking the block once
		is_broken = true
		emit_signal("block_broken")
		queue_free()  # Remove the block from the scene
