extends CanvasLayer

@export var next_scene_path: String = "res://scenes/Game.tscn"
@export var dialogue_lines: Array[String] = []

@onready var dialogue_label: Label = $DialogueControl/DialogueLabel
@onready var next_button: Button = $DialogueControl/NextButton

var current_line: int =0 


func _ready() -> void:
	if dialogue_lines.size() > 0:
		show_line(current_line)
	next_button.visibile = dialogue_lines.size() > 1 

func show_line(line_index: int) -> void:
	if line_index < dialogue_lines.size():
		await typewriter(dialogue_lines[line_index]) 
	else:
		change_scene()

func next_line() -> void: 
	current_line +=1
	show_line(current_line)
	
func change_scene() -> void: 
	if next_scene_path != " ":
		get_tree().change_scene_to_file(next_scene_path)

func _on_NextButton_pressed() -> void: 
	next_line()

func typewriter(text:String) -> void: 
	dialogue_label.text = " "
	for char in text:
		dialogue_label.text += char
		await get_tree().process_frame
