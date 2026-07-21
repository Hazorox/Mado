extends Node2D
@onready var night :=1
@onready var dialogue := get_tree().get_first_node_in_group("Dialogue")
@onready var slept_night :=false
@onready var worked_night:=0
@onready var pc_opened=false
func _process(_delta:float)->void:
	if night==4:
		await dialogue.show_dialogue(["Project Due Reached..."])
		if worked_night==3:
			await dialogue.show_dialogue(["Congrats!!! You have resisted all temptations and finished 100% of the project"])
		elif worked_night==2:
			await dialogue.show_dialogue(["You have finished most of the project, you got B+..."])
		elif worked_night==1:
			await dialogue.show_dialogue(["You finished a small part of the project, you deserved a C+ :("])
		else:
			await dialogue.show_dialogue(["You failed to work on the project...\nYou believe you will do better next time...","That's what you said last time also...\nAnd the loop continues..."])
		
		await dialogue.show_dialogue(["You have finished the game... Self Destruction in 5 seconds"])
		get_tree().create_timer(5)
		night=0
		slept_night=false
		worked_night=0
		pc_opened=false
		get_tree().change_scene_to_file("res://scenes/menu.tscn")
