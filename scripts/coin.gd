extends Node2D

var jump_time: float
var jump_duration: float = 0.5

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	jump_time = 0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var hero: CharacterBody2D = get_node("/root/Global/hero/CharacterBody2D")
	var distance_to_hero = hero.global_position.distance_to(global_position)
	if distance_to_hero < 100:
		var move = global_position.move_toward(hero.global_position, 360 * delta)
		global_position = move


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is Hero:
		var hero :Hero =  body
		hero.give_gold()
		queue_free()
