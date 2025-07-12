extends NPCsState

@export var shootingState: NPCsState

func enter() -> void:
	super()
	#print("[Enemy][State]: Die")
	parent.status_history.append(self)
	
	parent.shoot_ray_cast.enabled = false
	parent.player_detector.enabled = false
	shootingState.shooting_timer.stop()
	
	Global.saving_slats.slat1.enemies_killed.append(parent.get_rid())
	Global.save_game()

#func process_frame(_delta: float) -> NPCsState:
	#return null
