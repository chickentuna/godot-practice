extends Node2D

@export var MAX_COUNTDOWN = 1.0
var countdown := 1.0
@export var n_enemies := 4

var enemy_scene = preload("res://scenes/enemy.tscn")
var splash_scene = preload("res://scenes/splash.tscn")

var spawn_pad := 0
var map_end := Vector2(1920 - spawn_pad, -1152 + spawn_pad)

func _draw() -> void:
	#draw_rect(Rect2(spawn_pad,-spawn_pad,map_end.x - spawn_pad,map_end.y + spawn_pad), Color.AQUAMARINE, true, 2)
	pass

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	global_position.x = 0
	global_position.y = 0
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	countdown -= delta
	if countdown <= 0:
		countdown = MAX_COUNTDOWN
		for i in range(n_enemies):
			var enemy_parent = enemy_scene.instantiate()
			get_node("../Enemies").add_child(enemy_parent)
			var enemy: Enemy = enemy_parent.get_children(true)[0]
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
			enemy.health = 100
