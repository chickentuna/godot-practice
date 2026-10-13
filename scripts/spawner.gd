extends Node2D

@export var current_max_countdown:float = 10
var countdown : float = 0
var max_spawn_count = 20
var spawn_n := 150.0
var enemy_health = 50
var n_rounds :float= 1
var max_enemy_health := 200
var n_rounds_until_max_health_attained = 50
var boss_round = 25

var enemy_scene = preload("res://scenes/enemy.tscn")
var boss_scene = preload("res://scenes/boss.tscn")
var splash_scene = preload("res://scenes/splash.tscn")

var boss_music = preload("res://music/Le Grand Chase.mp3")

var spawn_pad := 0
var map_end := Vector2(1920 - spawn_pad, -1152 + spawn_pad)

func increase_difficulty():
	n_rounds += 1
	# desmos formula
	# \left(1-\frac{1}{2^{\frac{x}{10}}}\right)\cdot200
	enemy_health = (1 - (1 / (2 ** (n_rounds / (n_rounds_until_max_health_attained / 5)))))\
		* max_enemy_health
	print(enemy_health)
	spawn_n += 0.67
	if spawn_n > max_spawn_count:
		spawn_n = max_spawn_count

func _draw() -> void:
	# draw_rect(Rect2(spawn_pad,-spawn_pad,map_end.x - spawn_pad,map_end.y + spawn_pad), Color.AQUAMARINE, true, 2)
	pass

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	global_position.x = 0
	global_position.y = 0

func get_enemies_on_screen() -> int:
	var enemies := get_tree().get_nodes_in_group("enemies")
	return enemies.size()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	countdown -= delta
	var round_label:Label = get_node("/root/Global/HUD/RoundLabel")
	round_label.text = "Round {}/{}".format([int(n_rounds) - 1, boss_round], "{}")
			
	if countdown <= 0 or get_enemies_on_screen() == 0:
		if (n_rounds == boss_round):
			spawn_boss()
			countdown = 2147483647
			n_rounds += 1
			return
		countdown = current_max_countdown
		current_max_countdown -= 1
		if current_max_countdown <= 0:
			current_max_countdown = 10
		increase_difficulty()
		for i in range(floor(spawn_n)):
			var enemy_parent = enemy_scene.instantiate()
			get_node("../Enemies").add_child(enemy_parent)
			var enemy: Enemy = enemy_parent.get_children(true)[0]
			spawn_enemy(enemy, enemy_health)

func spawn_boss():
	var music: AudioStreamPlayer2D = get_node("/root/Global/Music")
	music.stream = boss_music
	music.play(0)
	var enemy_parent = boss_scene.instantiate()
	get_node("../Enemies").add_child(enemy_parent)
	var enemy: Enemy = enemy_parent.get_children(true)[0]
	spawn_enemy(enemy, enemy_health * 50)

func spawn_enemy(enemy: Node, enemy_health: int):
	enemy.max_health = enemy_health
	enemy.health = enemy_health
	enemy.add_to_group("enemies")
	
	var spawn_from := Vector2(spawn_pad,-spawn_pad)
	var spawn_to := map_end
	var border = randi_range(1,4)
	if border == 1:
		spawn_to = Vector2(map_end.x, -spawn_pad)
	elif border == 2:
		spawn_to = Vector2(spawn_pad, map_end.y)
	elif border == 3:
		spawn_from = Vector2(map_end.x, -spawn_pad)
	elif border ==4:
		spawn_from = Vector2(spawn_pad, map_end.y)
	enemy.position.x = randf_range(spawn_from.x, spawn_to.x)
	enemy.position.y = randf_range(spawn_from.y, spawn_to.y)
	var splash := splash_scene.instantiate()
	get_node("/root/Global/Splashes").add_child(splash)
	splash.global_position = enemy.global_position
	
