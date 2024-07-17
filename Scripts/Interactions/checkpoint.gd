extends Area2D

var checkpoint_manager
@export var playerGroup: String

func _ready():
	checkpoint_manager = get_parent().get_parent().get_node("CheckpointManager")


func _on_body_entered(body):
	if body.is_in_group(playerGroup):
		checkpoint_manager.last_position = $RespawnPoint.global_position
