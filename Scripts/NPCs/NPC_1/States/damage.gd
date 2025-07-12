extends NPCsState
#NOTE: Complete Damage Functionalities

@export var idleState: NPCsState
@export var wanderingState: NPCsState
@export var chasingState: NPCsState
@export var deathState: NPCsState

var damaging_anime_finished: bool = false
var previous_state: NPCsState

@onready var damaging_timer: Timer = $"../../Timers/DamagingTimer"

func enter() -> void:
	super()
	#print("[Enemy][State]: Damage")
	
	parent.damaged = false
	
	parent.sprite.material.set_shader_parameter("flashValue", 1.0)
	damaging_timer.start()
	
	parent.health_bar.value -= parent.damage_value
	parent.health = parent.health_bar.value
	
	previous_state = parent.status_history.back()
	
	if previous_state == idleState || previous_state == wanderingState:
		previous_state = chasingState

func process_frame(_delta: float) -> NPCsState:
	if damaging_anime_finished && parent.health > 0:
		damaging_anime_finished = false
		return previous_state
	
	elif damaging_anime_finished && parent.health <= 0:
		damaging_anime_finished = false
		return deathState
	
	return null


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "Damaging":
		damaging_anime_finished = true


func _on_damaging_timer_timeout() -> void:
	parent.sprite.material.set_shader_parameter("flashValue", 0.0)
	damaging_anime_finished = true
