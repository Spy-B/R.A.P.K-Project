extends NPCsState

@export var idleState: NPCsState
@export var wanderingState: NPCsState
@export var chasingState: NPCsState
@export var shootingState: NPCsState
@export var talkingState: NPCsState
@export var damagingState: NPCsState
@export var deathState: NPCsState

@export_range(0, 1, 0.02) var reloadingTime: float = 1.0

@onready var reloading_timer: Timer = $"../../Timers/ReloadingTimer"
var can_fire: bool = true
var reloaded: bool = false

func enter() -> void:
	super()
	#print("[Enemy][State]: Reload")
	parent.status_history.append(self)
	
	can_fire = false
	
	reloading_timer.wait_time = reloadingTime
	reloading_timer.start()

func process_frame(_delta: float) -> NPCsState:
	if parent.damaged:
		return damagingState
	
	if reloaded:
		return idleState
	
	return null


func _on_reloading_timer_timeout() -> void:
	var ammo_needed: int = (parent.maxAmmo - parent.ammoInMag)
	
	if parent.ammoInMag == 0 && parent.extraAmmo >= ammo_needed || parent.ammoInMag < parent.maxAmmo && parent.extraAmmo != 0 && parent.extraAmmo >= ammo_needed:
		parent.extraAmmo -= ammo_needed
		parent.ammoInMag += ammo_needed
		
	elif parent.ammoInMag == 0 && parent.extraAmmo < ammo_needed || parent.extraAmmo < ammo_needed:
		parent.ammoInMag += parent.extraAmmo
		parent.extraAmmo = 0
	
	can_fire = true
	reloaded = true
	reloading_timer.stop()
