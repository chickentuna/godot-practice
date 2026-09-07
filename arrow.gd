class_name Arrow extends Node2D

@export var is_moving := false

func _ready() -> void:
	pass # Replace with function body.


func _process(delta: float) -> void:
	if !is_moving:
		return
	var direction := Vector2(5, 0).rotated(rotation)
	position += direction


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is Enemy:
		var enemy:Enemy = body
		enemy.queue_free()
