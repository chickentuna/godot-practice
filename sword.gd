extends Node2D

@export var angVelocity :float = 4

var swordScene = preload("res://projectile.tscn")
var sword
var swordAngle = 0

func _ready() -> void:
	sword = swordScene.instantiate()
	get_node("/root/Global/hero/CharacterBody2D").add_child(sword)
	
func get_sword_level() -> int:
	var weapons := get_node("/root/Global/Weapons")
	var sword_level: int = weapons.sword_level
	return sword_level

func spin_sword(delta: float) -> void:	
	var sword_level := get_sword_level()
	swordAngle += delta * (angVelocity * sword_level/5)
	var angVect := Vector2.from_angle(swordAngle) * 100
	sword.position = angVect
	

func _physics_process(delta: float) -> void:
	spin_sword(delta)
	
