extends CharacterBody2D

var movementWeight: float = 0.2
var health: int = 100
var player_detected: bool = false
var cool_down: bool = true


@export_enum("Enemy", "Friendly") var NpcType = 0
@export var player: CharacterBody2D
@export var playerGroup: String = "Player"

@export var ammoInMag: int = 9
@export var maxAmmo: int = 9
@export var extraAmmo: int = 999

@export_group("Dielogue Settings")
@export var dialogueJson: JSON
@onready var state: Dictionary = {}

@onready var sprite: Sprite2D = $Sprite2D
@onready var collision_shape: CollisionShape2D = $CollisionShape2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer

@onready var hit_collision: CollisionShape2D = $Sprite2D/Areas/HitArea/HitCollision

@onready var g_ray_cast: RayCast2D = $Sprite2D/RayCasts/GRayCast
@onready var w_ray_cast: RayCast2D = $Sprite2D/RayCasts/WRayCast
@onready var shoot_ray_cast: RayCast2D = $Sprite2D/RayCasts/ShootRayCast
@onready var player_detector: RayCast2D = $Sprite2D/RayCasts/PlayerDetector

@onready var gun_barrel: Marker2D = $Sprite2D/GunBarrel

@onready var npcs_state_machine: Node = $NPCsStateMachine

@onready var rgs_timer: Timer = $Timers/RGSTimer
#@onready var cooldown_period_timer: Timer = $Timers/CooldownPeriodTimer

@onready var dialogue_box: Control = $UI/DialogueBox
@onready var ez_dialogue: EzDialogue = $UI/DialogueBox/EzDialogue

func _ready() -> void:
	npcs_state_machine.init(self, sprite, animation_player, gun_barrel, rgs_timer)
	
	(ez_dialogue as EzDialogue).start_dialogue(dialogueJson, state)

func _unhandled_input(event: InputEvent) -> void:
	npcs_state_machine.process_input(event)

func _physics_process(delta: float) -> void:
	npcs_state_machine.process_physics(delta)

func _process(delta: float) -> void:
	npcs_state_machine.process_frame(delta)
	
	if player_detector.get_collider() == player:
		player_detected = true
		cool_down = false
	elif !player_detector.get_collider() == player:
		player_detected = false


func _on_ez_dialogue_dialogue_generated(response: DialogueResponse) -> void:
	dialogue_box.add_text(response.text)
