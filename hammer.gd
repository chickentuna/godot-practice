class_name Hammer extends Node2D

@export var is_moving := false
@export var speed : float= 0
@export var dir_angle : float= 0

var explosion_scene = preload("res://explosion.tscn")

var time :float= 0

func _ready() -> void:
	time = 0
	pass # Replace with function body.


func _process(delta: float) -> void:
	if !is_moving:
		return
	time += delta
	var direction := Vector2(speed * delta, 0).rotated(dir_angle)
	position += direction
	var sprite: Sprite2D = get_node("sprite")
	sprite.rotation += delta * 10
	
	var freq = time * 3
	var ampl = 350
	sprite.position.y = -sin(freq) * ampl
	if sprite.position.y > 0:
		var explosion = explosion_scene.instantiate()
		get_node("/root").add_child(explosion)
		explosion.global_position = global_position
		
		queue_free()


func _on_area_2d_body_entered(body: Node2D) -> void:
	return
	#if body is Enemy:
	#	var enemy:Enemy = body
	#	enemy.queue_free()
