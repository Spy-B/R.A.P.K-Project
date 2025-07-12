extends Area2D

@export var checkpoint_manager: Node
@export var player: CharacterBody2D
@export var lightOn: bool = false
#@export var lvl_number: int

@onready var collision_shape: CollisionShape2D = $CollisionShape2D
@onready var respawn_point: Marker2D = $RespawnPoint

var checkpoint_id: float


func _ready() -> void:
	#Generate a checkpoint unique id depending on the position
	checkpoint_id = (global_position.x + global_position.y) * 100.0
	
	if Global.current_slat.checkpoints_taken.has(checkpoint_id):
		monitoring = false
	
	if lightOn:
		$PointLight2D.enabled = true
	else:
		$PointLight2D.enabled = false

func _on_body_entered(body: Node) -> void:
	if body == player:
		checkpoint_manager.last_position = respawn_point.global_position
		
		#Global.current_slat.lvl_number.append(lvl_number)
		Global.current_slat.checkpoints_taken.append(checkpoint_id)
		Global.save_game("checkpoint", checkpoint_manager.last_position)
		
		body.ui.saving_loading()
		
		set_deferred("monitoring", false)
