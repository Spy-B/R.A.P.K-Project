extends Node

@export var startingState: State
var currentState: State

func init(parent: CharacterBody2D, gun_barrel: Marker2D, animation: AnimationPlayer, coyote_timer: Timer, jump_buffer_timer: Timer) -> void:
	for child in get_children():
		child.parent = parent
		child.animation = animation
		child.gun_barrel = gun_barrel
		child.coyote_timer = coyote_timer
		child.jump_buffer_timer = jump_buffer_timer
	
	change_state(startingState)

func change_state(new_state: State) -> void:
	if currentState:
		currentState.exit()
	
	currentState = new_state
	currentState.enter()

func process_physics(delta: float) -> void:
	var new_state = currentState.process_physics(delta)
	if new_state:
		change_state(new_state)

func process_input(event: InputEvent) -> void:
	var new_state = currentState.process_input(event)
	if new_state:
		change_state(new_state)

func process_frame(delta: float) -> void:
	var new_state = currentState.process_frame(delta)
	if new_state:
		change_state(new_state)
