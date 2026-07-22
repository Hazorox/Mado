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
				await dialogue.show_dialogue(["[!!!] FINAL PROJECT : Due in {0} Days".format([4-Game.night])])
				Game.pc_opened=true
			else:
				if Game.night==1:
					pc_choice(["[Discord DM] : Yo Hop on rq we will start.","Where are you????"],["Hop On","Work for the Night"],"You spend all night playing recklessly","You work for the night...")
				elif Game.night==2:
					pc_choice(["[NEW NOTIFICATION]: You were mentioned in a post online"],["Check","Ignore and open Project"],"You Opened...It was a meme that you saw 10 times before\nYou scroll mindlessly...","You ignore and continue working on the project")
				elif Game.night==3:
					pc_choice(["[EMAIL]: A game on your wishlist is now on sale!!!"],["Buy Game","Work & Buy Later"],"You buy the game...\nIt's pretty cool... You spend the night playing...","You Ignore and finish your project and submit :D")
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

func pc_choice(text,choices,choice1Result,choice2Result)->void:
	await dialogue.show_dialogue(text)
	var choice = await dialogue.interact(choices)
	if choice==0:
		await dialogue.show_dialogue([choice1Result])
		Game.night+=1
		await advance_night()
	else:
		await dialogue.show_dialogue([choice2Result])
		Game.night+=1
		Game.worked_night+=1
		await advance_night()



#await dialogue.show_dialogue()
					#var idk_choice = await dialogue.interact(["Hop On","Work for the Night"])
					#if idk_choice == 0:
						#await dialogue.show_dialogue(["You Play for the entire night without a sense of time..."])
						#advance_night()
						#Game.night+=1
					#if idk_choice == 1:
						#await dialogue.show_dialogue(["You make big progress on the project"])
						#Game.worked_night+=1
						#advance_night()
						#Game.night+=1
