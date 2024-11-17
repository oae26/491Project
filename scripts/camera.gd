extends Camera2D

@export var background_width: float = 3000
@export var background_height: float = 2000

func _ready() -> void:
	var screen_width = get_viewport().size.x
	var screen_height = get_viewport().size.y
	
	# Set the camera limits
	limit_left = 0
	limit_right = background_width - screen_width
	limit_top = 0
	limit_bottom = background_height - screen_height

	# Enable smooth camera movement (optional)
	position_smoothing_enabled = true
	position_smoothing_speed = 5.0  # Adjust for desired smoothness
