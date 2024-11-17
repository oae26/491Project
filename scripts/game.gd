extends Node2D

@onready var pause_menu = $PauseMenu
var paused = false
# Called when the node enters the scene tree for the first time.

func _on_block_broken() -> void:
	print("broken block")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("pause"):
			pauseMenu()

func pauseMenu() -> void:
	if paused:
		pause_menu.hide()
		get_tree().paused = false
	else:
		pause_menu.show()
		get_tree().paused = true
	paused = !paused
