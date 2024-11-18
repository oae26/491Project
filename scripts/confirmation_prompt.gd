class_name ConfirmationPrompt
extends Control

@onready var yes_btn = $Panel/HBoxContainer/YesBtn as Button
@onready var no_btn = $Panel/HBoxContainer/NoBtn as Button

signal exit_confirmation_prompt
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	handle_signals()
	set_process(false)

func on_yes_btn_pressed() -> void:
	get_tree().quit()

func on_no_btn_pressed() -> void:
	exit_confirmation_prompt.emit()
	set_process(false)

func handle_signals() -> void:
	yes_btn.button_down.connect(on_yes_btn_pressed)
	no_btn.button_down.connect(on_no_btn_pressed)
