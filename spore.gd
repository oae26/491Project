class_name Spore
extends CharacterBody2D


const SPEED = 300.0
const SPORE_VELOCITY = -200.0
const SPORE_SCENE = preload("res://spore.tscn")


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	velocity.y = SPORE_VELOCITY
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()

func launch() -> bool:
	return true
