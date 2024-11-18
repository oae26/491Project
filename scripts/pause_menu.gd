extends Control

@onready var resume_btn = $Panel/VBoxContainer/ResumeBtn as Button
@onready var quit_btn = $Panel/VBoxContainer/QuitBtn as Button
@onready var confirmation_prompt = $ConfirmationPrompt as ConfirmationPrompt
@onready var yes_btn = $ConfirmationPrompt/Panel/HBoxContainer/YesBtn
@onready var no_btn = $ConfirmationPrompt/Panel/HBoxContainer/NoBtn
@onready var panel = $Panel as Panel

var _is_paused:bool = false:
	set = set_paused

func _ready() -> void:
	handle_pause_signals()
	
func _on_Pause_Input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		_is_paused = !_is_paused

func set_paused(value:bool) -> void:
	_is_paused = value
	get_tree().paused = _is_paused
	visible = _is_paused

func on_resume_btn_pressed() -> void:
	print("Resume pressed")
	_is_paused = false

func on_quit_btn_pressed() -> void:
	print("Load Confirm Prompt")
	panel.visible = false
	confirmation_prompt.set_process(true)
	confirmation_prompt.visible = true
	yes_btn.grab_focus()

func on_no_btn_pressed() -> void:
	panel.visible = true
	confirmation_prompt.visible = false
	confirmation_prompt.set_process(false)
	panel.set_process(true)
	quit_btn.grab_focus()

func handle_pause_signals() -> void:
	resume_btn.button_down.connect(on_resume_btn_pressed)
	quit_btn.button_down.connect(on_quit_btn_pressed)
	no_btn.button_down.connect(on_no_btn_pressed)
