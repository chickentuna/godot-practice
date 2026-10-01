class_name Hero extends CharacterBody2D

const BASE_SPEED = 300.0
@onready var sprite = $AnimatedSprite2D
@onready var collision_detector = $Area2D
@onready var hit_cd_timer = $Timer
@export var speedMod := 1
@export var gold := 0

@export var max_hp := 1
@export var hp := 1

var is_on_hit_cd := false

var coin_sound: AudioStream = preload("res://sounds/DIIing.wav")

func _ready() -> void:
	load_save()
	sprite.play("idle")


func _physics_process(delta: float) -> void:
	
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var xdirection := Input.get_axis("ui_left", "ui_right")
	var ydirection := Input.get_axis("ui_up", "ui_down")
	
	var speed := BASE_SPEED * speedMod
	
	var inputVect := Vector2(xdirection, ydirection)
	
	if inputVect.is_zero_approx():
		sprite.play("idle")
	else:
		sprite.play("move")
	
	if inputVect.is_zero_approx():
		velocity.x = move_toward(velocity.x, 0, BASE_SPEED/2)
		velocity.y = move_toward(velocity.y, 0, BASE_SPEED/2)
		return
	
	inputVect = inputVect.normalized()
	
	velocity.x = inputVect.x * speed
	velocity.y = inputVect.y * speed
	
	if inputVect.x > 0:
		sprite.flip_h = false
	if inputVect.x < 0:
		sprite.flip_h = true
	move_and_slide()

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is Enemy:
		if is_on_hit_cd:
			return
		hp -= 1
		var progress_bar: TextureProgressBar = get_node("/root/Global/HUD/healthbar/ProgressBar")
		progress_bar.value = (float(hp) / float(max_hp)) * 100
		if hp <= 0:
			call_deferred("ded")
			return
		collision_detector.scale = Vector2(0, 0)
		collision_detector.position = Vector2(-999999, -999999)
		hit_cd_timer.start(1.0)
		is_on_hit_cd = true

func _on_hit_cd_timeout() -> void:
	collision_detector.scale = Vector2(1, 1)
	collision_detector.position = Vector2(0, 0)
	is_on_hit_cd = false

func give_gold():
	gold += 1
	var label:Label = get_node("/root/Global/HUD/GoldLabel")
	label.text = 'Gold: ' + str(gold)
	get_node("/root/Global/SoundManager").play(coin_sound, false)
	
func get_save() -> Dictionary:
	return {
		"gold": gold,
		"speed": speedMod,
		"health": max_hp
	}

func save_game():
	var hero_save := get_save()
	var weapons_save : Dictionary = get_node("/root/Global/Weapons").get_save()
	var save: Dictionary = {
		"hero": hero_save,
		"weapons": weapons_save,
	}
	var save_file = FileAccess.open("user://savegame.save", FileAccess.WRITE)
	print(JSON.stringify(save))
	save_file.store_line(JSON.stringify(save))
	save_file.close()
	pass
	
func load_save():
	var save_string := FileAccess.get_file_as_string("user://savegame.save")
	if save_string == "":
		return
	var json = JSON.new()
	var res := json.parse(save_string)
	
	print(json.data)
	self.max_hp = json.data.hero.health
	self.hp = self.max_hp
	self.gold = json.data.hero.gold
	get_node("/root/Global/Weapons").load_save(json.data.weapons)

var is_deading := false

func ded():
	if (is_deading):
		return
	is_deading = true
	print("ded")
	save_game()
	get_tree().change_scene_to_file("res://scenes/upgrades.tscn")
	pass
