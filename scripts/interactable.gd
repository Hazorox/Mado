extends Area2D
@export var action = "action"
@onready var interactable:bool = false

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
	print(action)
