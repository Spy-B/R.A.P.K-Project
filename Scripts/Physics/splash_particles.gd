extends Node2D

@onready var timer = $Timer
@onready var particle = $GPUParticles2D

func _ready():
	timer.wait_time = particle.lifetime
	timer.start()

func _on_Timer_timeout():
	queue_free()
