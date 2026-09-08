class_name Enemy extends CharacterBody2D
@onready var sprite = $AnimatedSprite2D
var dust_scene = preload("res://scenes/dust.tscn")

var death_sound: AudioStream = preload("res://sounds/death.wav")
const SPEED = 100
var hero

@export var goal_vector:Vector2
@export var sep_vector:Vector2

func get_hit() -> void:
	var dust := dust_scene.instantiate()
	get_node("/root").add_child(dust)
	dust.global_position = global_position
	
	get_node("/root/Global/SoundManager").play(death_sound, false)
	
	get_parent().queue_free()

func _ready() -> void:
	hero = get_node("/root/Global/hero").get_children(false)[0]
	sprite.play("default")

func _physics_process(delta: float) -> void:
	if hero == null:
		return
	
	var target : Vector2 = hero.global_position
	var goal_direction := global_position.direction_to(target)
	var direction_steer_away_other := get_separation_vector()
	
	#---debug---
	sep_vector = direction_steer_away_other
	goal_vector = goal_direction
	#---end---	
	
	var direction = (goal_direction * 2 + direction_steer_away_other).normalized()
	
	if not direction.is_zero_approx():
		direction = direction.normalized()
	velocity = direction * SPEED
	sprite.flip_h = velocity.x < 0
		
	move_and_slide()
	
func get_separation_vector() -> Vector2:
	var enemies := get_node("/root/Global/Enemies").get_children()
	var vector := Vector2(0,0)
	for e_parent:Node2D in enemies:
		var e: Enemy = e_parent.get_node("CharacterBody2D")
		if e == self:
			continue
		var d := e.global_position.distance_to(global_position)
		vector += e.global_position.direction_to(global_position) * 400/d
	return vector / enemies.size()
