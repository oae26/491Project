extends Control

@onready var main = $"../../"
signal resume_game 
func _on_resume_pressed() -> void:
	main.pauseMenu()  # Call the pauseMenu function from the main script
	emit_signal("resume_game")  #  Emit a signal to notify the main game to unpause


func _on_quit_pressed() -> void:
	print("Quit button pressed")  # For debugging
	get_tree().quit()  # Quit the game
