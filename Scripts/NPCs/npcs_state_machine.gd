extends Node

@export var startingState: NPCsState
var currentState: NPCsState

func init(parent: CharacterBody2D, sprite: Sprite2D, animation: AnimationPlayer, gun_barrel: Marker2D, rgs_timer: Timer) -> void:
	for child in get_children():
		child.parent = parent
		child.sprite = sprite
		child.gun_barrel = gun_barrel
		child.animation = animation
		child.rgs_timer = rgs_timer
	
	change_state(startingState)

func change_state(new_state: NPCsState) -> void:
	if currentState:
		currentState.exit()
	
	currentState = new_state
	currentState.enter()

func process_physics(delta: float) -> void:
	var new_state: NPCsState = currentState.process_physics(delta)
	if new_state:
		change_state(new_state)

func process_input(event: InputEvent) -> void:
	var new_state: NPCsState = currentState.process_input(event)
	if new_state:
		change_state(new_state)

func process_frame(delta: float) -> void:
	var new_state: NPCsState = currentState.process_frame(delta)
	if new_state:
		change_state(new_state)
