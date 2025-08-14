#@tool
extends Node2D

@export_group("Properties")
@export_multiline var letterText: String
#@export var playerGroup: String = "Player"
@export var letterTexture: Texture
@export var animatedLetterSprite: SpriteFrames
@export var animeName: StringName = "default"
@export var letterTextureScale: float = 1.0

@export var player: CharacterBody2D

@onready var sprite: Sprite2D = $Sprite2D
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var ui: CanvasLayer = $UI
@onready var texture_rect: TextureRect = $UI/Control/TextureRect
@onready var label: Label = $UI/Control/Label
@onready var quit: Button = $UI/Control/Quit

var player_in_range: bool = false

func _ready() -> void:
	apply_properties()
	
	
	if OS.get_name() == "Android":
		quit.visible = true

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("interact") && player_in_range:
		_on_quit_pressed()

func _process(_delta: float) -> void:
	if Engine.is_editor_hint():
		apply_properties()

func apply_properties() -> void:
	if letterText:
		label.text = letterText
	
	if animatedLetterSprite:
		animated_sprite.sprite_frames = animatedLetterSprite
		animated_sprite.scale.x = letterTextureScale
		animated_sprite.scale.y = letterTextureScale
		
	elif letterTexture:
		sprite.texture = letterTexture
		sprite.scale.x = letterTextureScale
		sprite.scale.y = letterTextureScale


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body == player:
		player_in_range = true
		body.runtime_vars.interaction_detected = true

func _on_area_2d_body_exited(body: Node2D) -> void:
	if body == player:
		player_in_range = false
		body.runtime_vars.interaction_detected = false


func _on_quit_pressed() -> void:
	ui.visible = !ui.visible
	player.ui.interact_key.visible = !player.ui.interact_key.visible
	
	if OS.get_name() == "Android":
		player.phone_ui.visible = !player.phone_ui.visible
	
	get_tree().paused = !get_tree().paused
