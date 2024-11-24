extends CharacterBody2D

const SPEED = 200.0

var dir : float
var spawnPos : Vector2
var spawnRot : float
#var spore_cnt = $Player.spore_count

func _ready():
	global_position = spawnPos + Vector2(-50,-85)
	global_rotation = spawnRot

func _physics_process(delta):
	velocity = Vector2(0, -SPEED).rotated(dir)

	if Input.is_action_just_pressed("move_left"):
		pass
	if Input.is_action_just_pressed("move_right"):
		pass
	if Input.is_action_just_pressed("move_up"):
		pass
	if Input.is_action_just_pressed("move_down"):
		pass
	move_and_slide()
	
func destroy():
	emit_signal("spore_destroyed")
	queue_free()

func _on_Spore_area_entered(area: Area2D):
	destroy() 

# this function may or may not be needed
func _on_Spore_body_entered(body: Node2D):
	destroy()

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	print("spore destroyed")
	queue_free()
