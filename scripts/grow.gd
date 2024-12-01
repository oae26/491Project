extends Node

var current_seed: Node = null
var player = null

func _ready() -> void:
	# Ensure the signal is connected
	$Area2D.body_entered.connect(_on_Area2D_body_entered)
	player = get_tree().get_current_scene().get_node("Player")
	
	# Optional fade-out effect
	var tween = create_tween()
	tween.tween_property(self, "modulate:a", 0, 0.4)
	tween.tween_callback(queue_free)

func _on_Area2D_body_entered(body: Node) -> void:
	print("Collision detected with:", body.name)  # Debug
	if body.is_in_group("platform_seeds"):  # Check for platform seeds
		print("Growing a platform seed:", body.name)
		current_seed = body
		current_seed.grow_seed()  # Grow the platform seed
		current_seed = null
	elif body.is_in_group("final_seed"):
		current_seed = body
		current_seed.grow_seed()  # Grow the platform seed
		current_seed = null
	elif body.is_in_group("jump_seeds"):  # Check for jump seeds
		print("Applying jump boost from seed:", body.name)
		player.jump()  # Directly apply a jump boost
		queue_free()
