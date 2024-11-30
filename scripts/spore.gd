extends CharacterBody2D

const SPEED = 400.0

var dir : float
var spawnPos : Vector2
var spawnRot : float

@export var flowers: Array = [
	{
		"texture": preload("res://art/Daffodil.png"),
		"message": "A new mindset begins to take root..."
	},
	{
		"texture": preload("res://art/Rose.png"),
		"message": "A new mindset begins to take root..."
	},
	{
		"texture": preload("res://art/Cosmo.png"),
		"message": "A new mindset begins to take root..."
	},
	{
		"texture": preload("res://art/LilyOfTheValley.png"),
		"message": "A new mindset begins to take root..."
	}
]

func _ready():
	add_to_group("spores")
	print(is_in_group("spores"))
	global_position = spawnPos + Vector2(-50,-85)
	global_rotation = spawnRot
	velocity = Vector2(0, -SPEED/2).rotated(dir)
	
func _physics_process(delta):
	if Input.is_action_just_pressed("move_left"):
		velocity.x -= SPEED
	if Input.is_action_just_pressed("move_right"):
		velocity.x += SPEED
	if Input.is_action_just_pressed("move_up"):
		velocity.y -= SPEED
	if Input.is_action_just_pressed("move_down"):
		velocity.y += SPEED
	if velocity.length() > SPEED:
		velocity = velocity.normalized() * SPEED
	var collision = move_and_collide(velocity * delta)
	if collision:
		handle_collision(collision)
	
func destroy():
	print("spore destroyed")
	queue_free()

func handle_collision(collision):
	var collider = collision.get_collider()
	if collider.is_in_group("blocks"):
		print("Spore collided with block")
		collider.destroy_block()
		on_block_destroyed()
		destroy()

func on_block_destroyed() -> void:
	# Trigger a thought or memory UI
	var thought_ui_scene = preload("res://scenes/thought_UI.tscn")
	var thought_ui_instance = thought_ui_scene.instantiate()
	
	var random_flower = flowers[randi() % flowers.size()]
	
	# Create a new Sprite2D node for the flower
	var flower_sprite = Sprite2D.new()
	flower_sprite.texture = random_flower["texture"]
	flower_sprite.position = global_position
	
	# Add the flower to the scene
	get_tree().get_current_scene().add_child(flower_sprite)
	
	# Display the associated message as a thought UI
	show_flower_message(global_position, random_flower["message"])

	# Assuming ThoughtUI scene has a `set_text` method

	# Add ThoughtUI to the current scene
	get_tree().get_current_scene().add_child(thought_ui_instance)

func show_flower_message(position: Vector2, message: String) -> void:
	var label = Label.new()
	label.text = message
	label.position = position + Vector2(0, -50)  # Position above the flower
	get_tree().get_current_scene().add_child(label)

	# Fade out and remove the label
	label.modulate = Color(1, 1, 1, 1)  # Fully opaque
	var timer = get_tree().create_timer(3.0)  # Create a timer for 3 seconds
	timer.timeout.connect(func():
		label.queue_free()  # Remove the label when the timer ends
	)

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	destroy()
