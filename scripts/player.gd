extends CharacterBody2D

const SPEED = 300.0
const JUMP_VELOCITY = -400.0
var screen_size
var current_block: Node = null
@onready var game = get_tree().get_root().get_node("Game")
@onready var SPORE = load("res://scenes/spore.tscn")
@onready var sporeTimer = $SporeTimer
@onready var area2d = $Area2D  # Replace with the actual path to your Area2D node

func _ready():
	screen_size = get_viewport_rect().size
	area2d.body_entered.connect(_on_Area2D_body_entered)  # Connect the signal
	area2d.body_exited.connect(_on_Area2D_body_exited)
func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	var direction := Input.get_axis("move_left", "move_right")
	if direction:
		velocity.x = direction * SPEED
		$AnimatedSprite2D.animation = "walk"
		$AnimatedSprite2D.play()
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		$AnimatedSprite2D.stop()
	if velocity.x < 0:
		$AnimatedSprite2D.flip_h = true
	else:
		$AnimatedSprite2D.flip_h = false
		
	# Create action for block breaking
	if Input.is_action_just_pressed("break_block") and current_block:
			print("block")
			current_block.destroy_block()
	
	if Input.is_action_just_pressed("spore_launch") and sporeTimer.get_time_left() == 0:
		launch_spore()

	move_and_slide()
func _on_Area2D_body_entered(body: Node) -> void:
	if body.is_in_group("blocks"):
		current_block = body
		print("entered area")
		print(current_block)

		# Connect to the block's destruction signal
		var callable_on_block_destroyed = Callable(self, "_on_block_destroyed")
		
		# Connect to the block's destruction signal if not already connected
		if not current_block.is_connected("block_broken", callable_on_block_destroyed):
			current_block.connect("block_broken", callable_on_block_destroyed)
		


func _on_Area2D_body_exited(body: Node) -> void:
	if body == current_block:  # Check if it's the same block
		current_block = null  # Clear the reference
		print("exited area")




func launch_spore():
	var spore = SPORE.instantiate()
	spore.dir = rotation
	spore.spawnPos = global_position
	spore.spawnRot = rotation
	game.add_child.call_deferred(spore)
	sporeTimer.start()
