extends Node2D

const MAX_COUNTDOWN = 1.0
var countdown := 1.0
var n_enemies := 4

var enemy_scene = preload("res://enemy.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	countdown -= delta
	if countdown <= 0:
		countdown = MAX_COUNTDOWN
		for i in range(n_enemies):
			var enemy = enemy_scene.instantiate()
			enemy.position = global_position + Vector2(i*100, 0)
			enemy.get_children(true)[0].add_to_group("enemies")
			get_parent().add_child(enemy)
		global_position.x = randf_range(300, 1300)
		global_position.x = randf_range(300, 800)
