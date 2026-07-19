extends Area2D
@export var action = "action"
@onready var interactable:bool = false
@onready var dialogue = $"../CanvasLayer/Dialogue"
@onready var night:=1
@onready var player = $"../body/player"
@onready var canvasLayer = $"../CanvasLayer"
func _ready()->void:
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)
func _process(_delta:float)->void:
	if (Input.is_action_just_pressed("interact") and interactable):
		interact()
func _on_body_entered(_area)->void:
	interactable=true
func _on_body_exited(_area)->void:
	interactable = false
func interact()->void:
	match action:
		"PC":
			pass
		"window":
			dialogue.show_dialogue(["The Sky is Clear... The Stars are Sparkling\nYou're filled with INSPIRATION","You decide to work and make progress on the project for the night..."])
			night+=1
			advance_night()
		"bed":
			await dialogue.show_dialogue(["Your place of comfort and rest..Your Bed..\nIt's looking hella comfy :3"])
			night+=1
			var bed_choice = await dialogue.interact(["Sleep for the Night","Continue"])
			if bed_choice==0:
				player.play("idleRed")
				advance_night()
			if bed_choice==1:
				get_tree().paused=false
		"wall":
			dialogue.show_dialogue(["Some of your interests framed on a wall...\nNothing Happens..."])
func advance_night()->void:
	canvasLayer.fade_in_out()
	get_tree().paused=false
