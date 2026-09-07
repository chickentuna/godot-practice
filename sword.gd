extends Node2D

@export var angVelocity := 4

var swordScene = preload("res://projectile.tscn")
var sword
var swordAngle = 0

func _ready() -> void:
	sword = swordScene.instantiate()
	get_node("/root/Global/hero/CharacterBody2D").add_child(sword)	
	
func spin_sword(delta: float) -> void:
	swordAngle += delta * angVelocity
	var angVect := Vector2.from_angle(swordAngle) * 100
	sword.position = angVect
	

func _physics_process(delta: float) -> void:
	spin_sword(delta)
	
