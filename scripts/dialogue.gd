class_name Dialogue
extends Control
@onready var text:Label = $diag/Text
@onready var user:Label = $diag/Name
@onready var choicesControl:HBoxContainer = $diag/choices
@onready var choice1:Label=$diag/choices/option1
@onready var choice2:Label=$diag/choices/option2
@onready var currentLine = 0
@onready var txtLines:Array = []
@onready var choices = []
@onready var select := $select
signal choice_made(index:int)
var selected_choice := 0
var choosing:=false
var just_opened := false
signal dialogue_closed
func _ready() -> void:
	Game.dialogue = self
	select.process_mode = Node.PROCESS_MODE_WHEN_PAUSED
	process_mode = Node.PROCESS_MODE_WHEN_PAUSED
	hide()

func show_dialogue(textLines:Array)->void:
	text.show()
	user.show()
	currentLine = 0
	txtLines = textLines
	get_tree().paused = true
	text.text = txtLines[currentLine]
	just_opened = true
	show()
	await dialogue_closed

func _process(_delta:float)->void:
	if just_opened:
		just_opened = false
		return
	
	if choosing:
		if Input.is_action_just_pressed("ui_left") or Input.is_action_just_pressed("ui_right"):
			selected_choice = 1 - selected_choice
			choose_color()
			select.play()
		elif Input.is_action_just_pressed("interact"):
			choice_made.emit(selected_choice)
			select.play()
		return

	if Input.is_action_just_pressed("interact"):
		if currentLine >= txtLines.size() - 1:
			hide_dialogue()
			currentLine = 0
			txtLines = []
		else:
			currentLine += 1
			text.text = txtLines[currentLine]

func hide_dialogue()->void:
	get_tree().paused=false
	hide()
	dialogue_closed.emit()

func interact(choicesArr:Array) -> int:
	choosing = true
	selected_choice = 0
	choice1.text=choicesArr[0]
	choice2.text=choicesArr[1]
	get_tree().paused = true
	show()
	text.hide()
	user.hide()
	choicesControl.show()
	just_opened = true
	choose_color()

	var result = await choice_made

	choicesControl.hide()
	choosing = false
	hide_dialogue()
	return result

func choose_color() -> void:
	choice1.add_theme_color_override("font_color", Color.YELLOW if selected_choice == 0 else Color.WHITE)
	choice2.add_theme_color_override("font_color", Color.YELLOW if selected_choice == 1 else Color.WHITE)
