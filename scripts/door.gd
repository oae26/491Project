extends StaticBody2D

@export var is_open: bool = false
@export var open_sprite: Texture  # Sprite when the door is open
@export var closed_sprite: Texture  # Sprite when the door is closed

@onready var sprite = $Sprite2D
@onready var collision_shape = $CollisionShape2D

func _ready() -> void:
	print("Door initialized. Collision shape:", collision_shape)
	update_door_state()

func open() -> void:
	if not is_open:
		is_open = true
		print("Door is opening...")
		update_door_state()

func close() -> void:
	if is_open:
		is_open = false
		print("Door is closing...")
		update_door_state()

func toggle() -> void:
	is_open = not is_open
	print("Door toggled. New state: ", is_open)
	print("Opening door:", name)
	update_door_state()

func update_door_state() -> void:
	# Update the sprite based on the door's state
	visible = not is_open  # Hide the door when it's open
	# Defer collision disabling to ensure it updates correctly
	if collision_shape:
		collision_shape.call_deferred("set", "disabled", is_open)
		print("Collision shape disabled:", is_open)
	else:
		print("Error: Collision shape not found!")
