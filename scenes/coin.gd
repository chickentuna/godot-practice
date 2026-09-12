extends Node2D

var jump_time: float
var jump_duration: float = 0.5

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	jump_time = 0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
