extends Node2D

@export var spawn_delay_s := 2.5
var spawn_timer := spawn_delay_s
@onready var weapons: Weapons = %Weapons
@onready var hero_root: Node2D = %hero
var rng = RandomNumberGenerator.new()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func get_hammer_level() -> int:
	var level: int = weapons.hammer_level
	return level

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	spawn_timer -= delta
	if (spawn_timer > 0 or get_hammer_level() < 1):
		return
	
	spawn_timer = spawn_delay_s
	var hero := hero_root.get_children(false)[0]
	
	var hammer_tpl := get_node("hammer")
	var hammerCount = 2 * get_hammer_level()
	
	for i in range(hammerCount):
		var hammer : Hammer = hammer_tpl.duplicate()
		add_child(hammer)
		hammer.is_moving = true
		hammer.dir_angle = rng.randf_range(-PI, PI)
		hammer.speed = rng.randf_range(100, 400)
		hammer.global_position = hero.global_position
		
