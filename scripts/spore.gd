extends CharacterBody2D

const SPEED = 400.0

var dir : float
var spawnPos : Vector2
var spawnRot : float

func _ready():
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
		destroy()

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	destroy()
