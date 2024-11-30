extends Node

var current_seed: Node = null
var player = null;


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player = get_tree().get_current_scene().get_node("Player")
	var tween = create_tween()
	tween.tween_property(self, "modulate:a",0,0.4)
	tween.tween_callback(queue_free)



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func _on_Area2D_body_entered(body: Node) -> void:
	print(body.name)
	print(body.get_groups())
	if body.is_in_group("seeds"):  # Check if it's a seed
		current_seed = body
		current_seed.get_parent().grow_seed()
		player.jump()
		current_seed = null
