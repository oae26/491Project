extends Area2D

@export var target_anchor_path: NodePath  # Anchor for respawning
@export var footsteps_upper_path: NodePath  # Path to the upper footsteps AudioStreamPlayer
@export var footsteps_lower_path: NodePath  # Path to the lower footsteps AudioStreamPlayer
@export var music_upper_path: NodePath  # Path to the upper layer music AudioStreamPlayer
@export var music_lower_path: NodePath  # Path to the lower layer music AudioStreamPlayer

func _on_Area2D_body_entered(body: Node) -> void:
	if body.name == "Player":
		# Set the respawn anchor
		var target_anchor = get_node_or_null(target_anchor_path)
		if target_anchor:
			body.last_anchor = target_anchor
			print("Player transitioned. New anchor set:", target_anchor.name)

		# Mark the player as being in a transition
		body.is_in_transition = true
		print("Player entered transition zone.")

func _on_Area2D_body_exited(body: Node) -> void:
	if body.name == "Player":
		# Handle footsteps and music switching after the transition
		switch_to_lower_layer_audio()
		body.is_in_transition = false
		print("Player exited transition zone.")

func switch_to_lower_layer_audio() -> void:
	var footsteps_upper = get_node_or_null(footsteps_upper_path)
	var footsteps_lower = get_node_or_null(footsteps_lower_path)
	var music_upper = get_node_or_null(music_upper_path)
	var music_lower = get_node_or_null(music_lower_path)

	# Switch footsteps
	if footsteps_upper and footsteps_lower:
		footsteps_upper.stop()
		footsteps_lower.play()
		print("Switched to lower layer footsteps.")

	# Switch music
	if music_upper and music_lower:
		music_upper.stop()
		music_lower.play()
		music_lower.loop  # Enable looping for lower music

		
