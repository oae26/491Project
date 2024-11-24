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
	#velocity = Vector2(0, -10).rotated(dir)
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
	move_and_slide()
	
func destroy():
	print("spore destroyed")
	queue_free()

func _on_Spore_area_entered(area: Area2D):
	destroy() 

# this function may or may not be needed
func _on_Spore_body_entered(body: Node2D):
	destroy()

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	destroy()
