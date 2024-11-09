extends Node2D

@onready var pause_menu = $CanvasLayer/PauseMenu
@onready var resume = $CanvasLayer/PauseMenu/MarginContainer/VBoxContainer/ResumeBtn
var paused = false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var block = preload("res://scenes/block.tscn").instantiate()
	block.position = Vector2(869, 300)  # Set position as needed
	block.add_to_group("blocks")  # Add block to group for easy detection

	# Use Callable for the method connection
	block.connect("block_broken", Callable(self, "_on_block_broken"))  # Connect the signal here

	add_child(block)

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
		resume.grab_focus()
		get_tree().paused = true
	paused = !paused
