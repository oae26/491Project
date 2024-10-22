extends CharacterBody2D

@export var SPEED := 100.0
var dir : float
var spawnPos : Vector2
var spawnRot : float

func _ready():
	global_position = spawnPos + Vector2(-50,-85)
	global_rotation = spawnRot

func _physics_process(delta):
	velocity = Vector2(0, -SPEED).rotated(dir)
	move_and_slide()
	
func destroy():
	queue_free()

func _on_Spore_area_entered(area: Area2D):
	destroy() 

# this function may or may not be needed
func _on_Spore_body_entered(body: Node2D):
	destroy()

func _on_visibility_notifier_screen_exited():
	queue_free()
