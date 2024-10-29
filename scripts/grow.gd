extends Node

var current_seed: Node = null


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var tween = create_tween()
	tween.tween_property(self, "modulate:a",0,0.4)
	tween.tween_callback(queue_free)



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func _on_Area2D_body_entered(body: Node) -> void:
	if body.is_in_group("seeds"):  # Check if it's a seed
		current_seed = body 
