extends Node2D

@export var spawn_delay_s := 1.0
var spawn_timer := spawn_delay_s

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func get_closest_enemy(hero: Node) -> Node:
	var enemies := get_tree().get_nodes_in_group("enemies")
	var closest_dist := 0
	var closest_enemy: Node = null
	for enemy in enemies:
		var enemy_dist: int = hero.global_position.distance_to(enemy.global_position)
		if enemy_dist < closest_dist || closest_enemy == null:
			closest_enemy = enemy
			closest_dist = enemy_dist
	return closest_enemy

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	spawn_timer -= delta
	if (spawn_timer > 0):
		return
	spawn_timer = spawn_delay_s
	var hero := get_node("/root/Global/hero").get_children(false)[0]
	var enemy := get_closest_enemy(hero)
	if enemy == null:
		return
	var arrow_tpl := get_node("arrow")
	var arrow := arrow_tpl.duplicate()
	arrow.is_moving = true
	arrow.rotation = Vector2(enemy.global_position - hero.global_position).angle()
	add_child(arrow)
	arrow.global_position = hero.global_position
