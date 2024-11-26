extends StaticBody2D

signal block_broken  # Signal emitted when the block is broken

var is_broken: bool = false  # Tracks whether the block is already broken

func _ready() -> void:
	add_to_group("blocks")  # Add this block to the "blocks" group

func destroy_block():
	if not is_broken:
		is_broken = true  # Mark the block as broken

		# Play the "break" animation (ensure the name matches your animation)
		$AnimatedSprite2D.animation = "break"
		$AnimatedSprite2D.play()

		# Connect the animation finished signal to handle the cleanup
		$AnimatedSprite2D.animation_finished.connect(_on_animation_finished)

		# Emit the block_broken signal with optional memory text or data
		emit_signal("block_broken")
		

func _on_animation_finished():
	# Check if the current animation is "break" to ensure proper timing
	if $AnimatedSprite2D.animation == "break":
		queue_free()  # Remove the block after the animation finishes
