extends Node2D

@export var respawn_position: Vector2  # Position to respawn the player

func _ready() -> void:
	# Ensure the respawn position is correctly set to this node's position
	respawn_position = global_position
func _on_Area2D_body_entered(body: Node) -> void:
	if body.name == "Player":  # Ensure it's the player
		body.last_anchor = self  # Set this anchor as the player's last respawn point
		print("Anchor activated:", name)
