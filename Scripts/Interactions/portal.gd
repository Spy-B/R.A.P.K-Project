extends Node2D
class_name portal

#@export_group("")
@export var texture: Texture
@export var animatedTexture: SpriteFrames
@export var animeName: StringName = "default"
@export var textureScale: float = 1.0

@export_enum("Right", "Left") var direction: int = 0

@export_group("Others")
@export var parent: Node
@export var player: CharacterBody2D

@onready var area_2d: Area2D = $Area2D
@onready var spawn_position: Marker2D = $Area2D/SpawnPosition


func _ready() -> void:
	pass

func _process(_delta: float) -> void:
	if !direction:
		area_2d.scale = -abs(area_2d.scale)
	elif direction:
		area_2d.scale = abs(area_2d.scale)
	
	pass


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body == player:
		print("yaaaay")
		parent.connected_portal = self
