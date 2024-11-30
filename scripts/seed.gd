extends StaticBody2D

signal seed_grow
# Called when the node enters the scene tree for the first time.
var grown: bool = false;
const platform = preload("res://scenes/platform.tscn")


func _ready() -> void:
	add_to_group("seeds")  # Add this seed to the "seeds" group
	#if is_in_group("seeds"):  # Check if it's a seed
	#	print("seed made")

func grow_seed():
	if not grown:
		grown = true
		emit_signal("seed_grow")
		var plat = platform.instantiate();get_parent().add_child(plat)
		plat.position = global_position - Vector2(-300, -200)
		queue_free()  
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass