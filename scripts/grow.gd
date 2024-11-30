extends Node

var current_seed: Node = null

func _ready() -> void:
	# Ensure the signal is connected
	$Area2D.body_entered.connect(_on_Area2D_body_entered)
	
	# Optional fade-out effect
	var tween = create_tween()
	tween.tween_property(self, "modulate:a", 0, 0.4)
	tween.tween_callback(queue_free)

func _on_Area2D_body_entered(body: Node) -> void:
	print("Collision detected with:", body.name)  # Debug
	if body.is_in_group("seeds"):  # Check if the detected body is part of the seeds group
		print("Found a seed:", body.name)
		current_seed = body
		current_seed.grow_seed()  # Call grow_seed directly on the detected seed
		current_seed = null
