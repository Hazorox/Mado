extends Area2D
@export var action = "action"
@onready var interactable:bool = false
@onready var dialogue = $"../CanvasLayer/Dialogue"
@onready var night:=1
@onready var player = $"../body/player"
@onready var canvasLayer = $"../CanvasLayer"
@onready var danger_audio = $"../danger"
func _ready()->void:
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)
	danger_audio.process_mode = Node.PROCESS_MODE_WHEN_PAUSED
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
			if Game.pc_opened==false:
				await dialogue.show_dialogue(["It's your computer...","You Open your mail for notifications"])
				danger_audio.play()
				await dialogue.show_dialogue(["[!!!] FINAL PROJECT : Due in {0} Days".format([3-Game.night])])
				Game.pc_opened=true
			else:
				if Game.worked_night==0:
					await dialogue.show_dialogue(["[Discord DM] : Yo Hop on rq we will start.","Where are you????"])
					var idk_choice = await dialogue.interact(["Hop On","Work for the Night"])
					if idk_choice == 0:
						await dialogue.show_dialogue(["You Play for the entire night without a sense of time..."])
						advance_night()
						Game.night+=1
					if idk_choice == 1:
						await dialogue.show_dialogue(["You make big progress on the project"])
						advance_night()
						Game.night+=1
		"window":
			await dialogue.show_dialogue(["The Sky is Clear... The Stars are Sparkling\nYou're filled with INSPIRATION"])
			if(Game.pc_opened==true):
				await dialogue.show_dialogue(["You decide to work and make progress on the project for the night..."])
				advance_night()
				Game.night+=1
				Game.worked_night+=1
		"bed":
			if Game.slept_night == false:
				await dialogue.show_dialogue(["Your place of comfort and rest..Your Bed..\nIt's looking hella comfy :3"])
				var bed_choice = await dialogue.interact(["Sleep for the Night","Continue"])
				if bed_choice==0:
					Game.slept_night=true
					advance_night()
					Game.night+=1
				if bed_choice==1:
					get_tree().paused=false
			else:
				await dialogue.show_dialogue(["A Comfy bed...You have wasted enough time sleeping"])
		"wall":
			dialogue.show_dialogue(["Some of your interests framed on a wall...\nNothing Happens..."])
func advance_night()->void:
	await canvasLayer.fade_in_out()
