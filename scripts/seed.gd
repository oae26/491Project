extends StaticBody2D

signal seed_grown

var grown: bool = false

func _ready() -> void:
	add_to_group("seeds")  # Add the parent Seed node to the seeds group

func grow_seed() -> void:
	if not grown:
		grown = true
		emit_signal("seed_grown")
		queue_free()  # Destroy the seed after growing
