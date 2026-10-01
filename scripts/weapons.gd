class_name Weapons
extends Node2D

@export var sword_level = 1
@export var arrow_level = 0
@export var hammer_level = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass
	

func get_save() -> Dictionary:
	return {
		"sword_level": sword_level,
		"arrow_level": arrow_level,
		"hammer_level": hammer_level
	}
