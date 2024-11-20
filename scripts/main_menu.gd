class_name MainMenu
extends Control

@onready var start_btn = $Panel/VBoxContainer/StartBtn as Button
@onready var quit_btn = $Panel/VBoxContainer/QuitBtn as Button
@onready var confirmation_prompt = $ConfirmationPrompt as ConfirmationPrompt
@onready var yes_btn = $ConfirmationPrompt/Panel/HBoxContainer/YesBtn
@onready var no_btn = $ConfirmationPrompt/Panel/HBoxContainer/NoBtn
@onready var panel = $Panel as Panel
@onready var level = preload("res://scenes/over_world.tscn") as PackedScene

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	start_btn.grab_focus()
	handle_signals()

func on_start_btn_pressed() -> void:
	get_tree().change_scene_to_packed(level)

func on_quit_btn_pressed() -> void:
	panel.visible = false
	confirmation_prompt.set_process(true)
	confirmation_prompt.visible = true
	yes_btn.grab_focus()
	#get_tree().quit()

func on_no_btn_pressed() -> void:
	panel.visible = true
	confirmation_prompt.visible = false
	confirmation_prompt.set_process(false)
	panel.set_process(true)
	quit_btn.grab_focus()

func handle_signals() -> void:
	start_btn.button_down.connect(on_start_btn_pressed)
	quit_btn.button_down.connect(on_quit_btn_pressed)
	no_btn.button_down.connect(on_no_btn_pressed)
