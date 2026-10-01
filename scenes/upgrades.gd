extends Control

@onready var gold_label = $Gold

var gold := 0
var max_hp := 0
var speed := 0
var arrow_level := 0
var hammer_level := 0
var sword_level := 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var save_string := FileAccess.get_file_as_string("user://savegame.save")
	var json = JSON.new()
	var res := json.parse(save_string)
	var save : Dictionary = json.data
	gold = int(save.hero.gold)
	max_hp = int(save.hero.max_hp)
	speed = int(save.hero.speed)
	hammer_level = int(save.weapons.hammer_level)
	arrow_level = int(save.weapons.arrow_level)
	sword_level = int(save.weapons.sword_level)

	gold_label.text = "Gold: " + str(gold)
	pass



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
