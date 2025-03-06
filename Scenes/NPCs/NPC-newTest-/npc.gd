extends CharacterBody2D

@onready var sprite: Sprite2D = $Sprite2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var gun_barrel: Marker2D = $Sprite2D/GunBarrel
@onready var player_detector_collision: CollisionShape2D = $Sprite2D/Areas/PlayerDetector/CollisionShape2D
@onready var g_ray_cast: RayCast2D = $Sprite2D/RayCasts/GRayCast
@onready var w_ray_cast: RayCast2D = $Sprite2D/RayCasts/WRayCast
@onready var shoot_ray_cast: RayCast2D = $Sprite2D/RayCasts/ShootRayCast

@onready var npcs_state_machine: Node = $NPCsStateMachine
@onready var rgs_timer: Timer = $Timers/RGSTimer
@onready var npc_label: Label = $UI/Label

var movementWeight: float = 0.2
var health: int = 100
var player_detected: bool = false
var cool_down: bool = true

@export_enum("Enemy", "Friendly") var NpcType = 0
@export var player: CharacterBody2D
@export var playerGroup: String = "Player"

func _ready() -> void:
	npcs_state_machine.init(self, sprite, animation_player, gun_barrel, rgs_timer)
	


func _unhandled_input(event: InputEvent) -> void:
	npcs_state_machine.process_input(event)

func _physics_process(delta: float) -> void:
	npcs_state_machine.process_physics(delta)

func _process(delta: float) -> void:
	npcs_state_machine.process_frame(delta)


func _on_player_detector_body_entered(body: Node2D) -> void:
	if body.is_in_group(playerGroup):
		player_detected = true

func _on_player_detector_body_exited(body: Node2D) -> void:
	if body.is_in_group(playerGroup):
		player_detected = false
