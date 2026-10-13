class_name Boss extends Enemy

@export var boss_speed = 200
var current_speed = 100
var time = 0

var pad := 0
var map_end := Vector2(1920 - pad, -1152 + pad)

func _init():
	
	enemy_damage = 20
	
var direction := Vector2(1, 1)

func die():
	get_tree().change_scene_to_file("res://scenes/end_game.tscn")

func _physics_process(delta: float) -> void:
	time += delta
	current_speed = boss_speed + (1+sin(time * 1))*200
	velocity = direction * current_speed
	move_and_slide()
	
	
	if position.x > map_end.x:
		direction = Vector2(-1, direction.y)
	if position.x < 0:
		direction = Vector2(1, direction.y)
	if position.y < map_end.y:
		direction = Vector2(direction.x, 1)
	if position.y > 0:
		direction = Vector2(direction.x, -1)

	# colour
	red_countdown = red_countdown - delta
	if red_countdown < 0:
		red_countdown = 0.0
	var red_prog = inverse_lerp(0.0, MAX_RED_COUNTDOWN, red_countdown)
	
	get_node("AnimatedSprite2D").modulate = Color(1, 1-red_prog, 1-red_prog, 1)
