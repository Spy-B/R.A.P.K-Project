extends Node

@export_range(0, 10) var timeScale = 1

@export_group("Enemy")
@export var is_chased : bool = false;

@export var ammo_in_mag = 0
@export var extra_ammo = 0
@export var max_ammo = 0

@export var enemy_ammo_in_mag = 0
@export var enemy_extra_ammo = 0
@export var enemy_max_ammo = 0

@export var meleeComboCounter = 0
@export var killComboCounter = 0

@export var enemiesLifePoints = 2
@export var playerHealthValue:float = 100

@export var inConversation := false

#@export var damage : bool = false;

var camera = null

var player_node: Node = null

var loadingScreen = preload("uid://b5b5dfh0nfqbt")
var nextScene = "uid://cvplrh5krh46n"
