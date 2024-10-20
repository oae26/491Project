extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0

@onready var sprite := $Sprite2D as Sprite2D
@onready var spore: Spore = sprite.get_node(^"Spore")


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()

	#var launching_spore := false
	#if Input.is_action_just_pressed("ui_cancel"):
	#	launching_spore

# Spore Mechanic: General idea is that action button is pressed
# Spore object is instantiated, and control is ceded to the spore
# Until the spore is detonated, or hits an object
