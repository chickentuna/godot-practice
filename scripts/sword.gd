extends Node2D

@export var angVelocity :float = 3
@export var distance :float = 150
@export var baseRotation :float = 0.8

var swordScene = preload("res://scenes/projectile.tscn")
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
		var angVect := Vector2.from_angle(curAngle) * distance
		sword.position = angVect
		sword.rotation = curAngle + baseRotation
		
		
	

func _physics_process(delta: float) -> void:
	spin_sword(delta)
	
