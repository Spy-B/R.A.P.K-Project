extends CharacterBody2D

@export_group("Physics")
var motion := Vector2.ZERO
@export var gravity = 98

@export_group("Movement")
@export var walkingSpeed := 150
@export var runningSpeed := 380

@export_group("Dialogue System")
var playerName: String = "SCARLET"

@export var dialogueFile: JSON
var state := {
	"playerName": playerName,
	"NpcName": "JONE"
}
@onready var dialogue_ui = $DialogueUI
@onready var dialogue_box = $DialogueUI/DialogueBox
@onready var ez_dialogue = $DialogueUI/DialogueBox/EzDialogue

var playerIsNearby :=  false
var inConversation := false

func _ready():
	#dialogue_ui.visible = false
	pass

@warning_ignore("unused_parameter")
func _process(delta):
	if Input.is_action_pressed("interact"):
		if playerIsNearby:
			inConversation = true
			set_process(false)
	
	start_dialogue()
	
	if $DialogueUI/DialogueBox/Label.text == "":
		inConversation = false

@warning_ignore("unused_parameter")
func _physics_process(delta):
	set_velocity(motion)
	set_up_direction(Vector2.UP)
	move_and_slide()
	motion = velocity
	
	Gravity()

func Gravity():
	if !is_on_floor():
		motion.y += gravity

func start_dialogue():
	# FIXME the Dialogue System
	if playerIsNearby && inConversation:
		dialogue_ui.visible = true
		(ez_dialogue as EzDialogue).start_dialogue(dialogueFile, state)
	elif playerIsNearby && !inConversation:
		dialogue_ui.visible = false

func _on_ez_dialogue_dialogue_generated(response):
	dialogue_box.clear_dialogue_box()
	
	dialogue_box.add_text(response.text)
