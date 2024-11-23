extends StaticBody2D
var memory_text: String = "A thought emerges..."  # Default memory text
signal block_broken
# Called when the node enters the scene tree for the first time.
var is_broken: bool = false
func _ready() -> void:
	add_to_group("blocks")  # Add this block to the "blocks" group

func destroy_block():
	if not is_broken:
		is_broken = true
		emit_signal("block_broken", memory_text)  # Include memory text
		queue_free()
