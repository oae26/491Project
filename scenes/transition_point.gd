extends Area2D

@export var target_anchor_path: NodePath

func _on_Area2D_body_entered(body: Node) -> void:
	if body.name == "Player":
		body.is_in_transition = true
		var target_anchor = get_node_or_null(target_anchor_path)
		if target_anchor:
			body.last_anchor = target_anchor
			print("Player transitioned. New anchor set:", target_anchor.name)

func _on_Area2D_body_exited(body: Node) -> void:
	if body.name == "Player":
		body.is_in_transition = false
		print("Player exited transition zone")
