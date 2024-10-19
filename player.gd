extends CharacterBody2D

const SPEED = 300.0
const JUMP_VELOCITY = -400.0

var current_block: Node = null

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
	
	if Input.is_action_just_pressed("ui_select") and current_block:
		current_block.destroy_block()# Call the break_block function


func _on_Area2D_body_entered(body: Node) -> void:
	if body.is_in_group("blocks"):  # Check if it's a block
		current_block = body  # Store the reference to the block

func _on_Area2D_body_exited(body: Node) -> void:
	if body == current_block:  # Check if it's the same block
		current_block = null  # Clear the reference
		
func _on_block_broken() -> void:
	print("the block has been broken!")
