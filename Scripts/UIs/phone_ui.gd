extends CanvasLayer

@onready var move_right_button: TextureButton = $Control/MoveRightButton
@onready var move_left_button: TextureButton = $Control/MoveLeftButton
@onready var jump: TextureButton = $Control/Jump
@onready var dash: TextureButton = $Control/Dash
@onready var attack: TextureButton = $Control/Attack
@onready var shoot: TextureButton = $Control/Shoot
@onready var interact: TextureButton = $Control/Interact
@onready var pause_button: TextureButton = $Control/PauseButton

func _on_move_right_button_pressed() -> void:
	pass

func _on_move_left_button_pressed() -> void:
	Input.action_press("move_left")
	pass

func _on_jump_pressed() -> void:
	#Input.is_action_just_pressed("jump")
	pass

func _on_dash_pressed() -> void:
	#Input.is_action_just_pressed("dash")
	pass

func _on_attack_pressed() -> void:
	#Input.is_action_just_pressed("attack")
	pass

func _on_shoot_pressed() -> void:
	#Input.is_action_just_pressed("shoot")
	pass

func _on_interact_pressed() -> void:
	#Input.is_action_just_pressed("interact")
	pass

func _on_pause_button_pressed() -> void:
	#Input.is_action_just_pressed("pause")
	pass
