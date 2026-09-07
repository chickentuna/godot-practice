extends Node2D

@export var angVelocity :float = 4

var swordScene = preload("res://projectile.tscn")
var swords: Array[Node] = []
var swordAngle = 0

func new_sword() -> Node:
	var sword := swordScene.instantiate()
	get_node("/root/Global/hero/CharacterBody2D").add_child(sword)
	swords.append(sword)
	return sword

func _ready() -> void:
	pass
	
func get_sword_level() -> int:
	var weapons := get_node("/root/Global/Weapons")
	var sword_level: int = weapons.sword_level
	return sword_level

func spin_sword(delta: float) -> void:	
	while get_sword_level() > swords.size():
		new_sword()
	swordAngle += delta * angVelocity
	for i in swords.size():
		var sword := swords[i]
		var curAngle = swordAngle + i * 2 * PI / swords.size()
		var angVect := Vector2.from_angle(curAngle) * 100
		sword.position = angVect
		
	

func _physics_process(delta: float) -> void:
	spin_sword(delta)
	
