class_name Upgrades extends Control

signal loaded

@onready var gold_label = $Gold

@export var gold := 0
@export var health := 0
@export var speed := 0
@export var arrow_level := 0
@export var hammer_level := 0
@export var sword_level := 0

func update_gold_label():
	gold_label.text = "Gold: " + str(gold)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var save_string := FileAccess.get_file_as_string("user://savegame.save")
	var json = JSON.new()
	var res := json.parse(save_string)
	print(res)
	var save : Dictionary = json.data
	gold = int(save.hero.gold)
	health = int(save.hero.health)
	speed = int(save.hero.speed)
	hammer_level = int(save.weapons.hammer_level)
	arrow_level = int(save.weapons.arrow_level)
	sword_level = int(save.weapons.sword_level)

	update_gold_label()
	
	loaded.emit()

func buy_upgrade(type, quantity:int, price:int) -> bool:
	if price > gold:
		return false
	gold -= price
	update_gold_label()
	self[type] = int(quantity) + int(self[type])
	loaded.emit()
	return true


func save_game():
	var save: Dictionary = {
		"hero": {
			"max_hp": health,
			"gold": gold
		},
		"weapons": {
			"arrow_level": arrow_level,
			"hammer_level": arrow_level,
			"sword_level": arrow_level,
		},
	}
	var save_file = FileAccess.open("user://savegame.save", FileAccess.WRITE)
	save_file.store_line(JSON.stringify(save))
	save_file.close()

func _on_play_pressed() -> void:
	save_game()
	get_tree().change_scene_to_file("res://scenes/level.tscn")
