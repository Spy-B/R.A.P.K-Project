extends CharacterBody2D

var movementWeight: float = 0.2
var health: int = 100
var player_detected: bool = false
var cool_down: bool = true
var damaged: bool = false
var damage_value: int
var waiting_time: float
var player_pos: Vector2

var status_history: Array = []

@export_enum("Enemy", "Friendly") var NpcType: int = 0
@export var player: CharacterBody2D

@export var ammoInMag: int = 9
@export var maxAmmo: int = 9
@export var extraAmmo: int = 999


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

##Roaming game states timer
@onready var rgs_timer: Timer = $Timers/RGSTimer
#@onready var cooldown_period_timer: Timer = $Timers/CooldownPeriodTimer

@onready var health_bar: TextureProgressBar = $TextureProgressBar

##Dialogue System
@export var dialogueJson: JSON
@onready var state: Dictionary = {}

#var starting_dialogue_pos: Vector2
#@onready var dialogue_position: Marker2D = $Sprite2D/DialoguePosition


func _ready() -> void:
	npcs_state_machine.init(self, sprite, animation_player, gun_barrel, rgs_timer)
	
	match NpcType:
		0:
			self.add_to_group("Enemy")
			
			set_collision_layer_value(17, true)
			set_collision_layer_value(25, false)
			
			set_collision_mask_value(9, true)
			
			randomize()
			waiting_time = randf_range(1, 3)
			
			rgs_timer.wait_time = waiting_time
			rgs_timer.start()
			
			shoot_ray_cast.enabled = true
			player_detector.enabled = true
		
		1:
			self.add_to_group("Friendly")
			
			set_collision_layer_value(17, false)
			set_collision_layer_value(25, true)
			
			set_collision_mask_value(9, false)
			
			health_bar.visible = false
			
			g_ray_cast.enabled = false
			w_ray_cast.enabled = false
			shoot_ray_cast.enabled = false
			player_detector.enabled = false
			
			#player_detector.target_position.x = 15.0
			#player_detector.position.x = 15.0
			
			#starting_dialogue_pos = dialogue_position.global_position

func _unhandled_input(event: InputEvent) -> void:
	npcs_state_machine.process_input(event)

func _physics_process(delta: float) -> void:
	npcs_state_machine.process_physics(delta)

func _process(delta: float) -> void:
	npcs_state_machine.process_frame(delta)
	
	if player_detector.get_collider() == player:
		player_detected = true
		cool_down = false
