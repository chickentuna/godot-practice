class_name Enemy extends CharacterBody2D
@onready var sprite = $AnimatedSprite2D
var dust_scene = preload("res://dust.tscn")

var death_sound: AudioStream = preload("res://death.wav")

const SPEED = 100
var hero

func get_hit() -> void:
	var dust := dust_scene.instantiate()
	get_node("/root").add_child(dust)
	dust.global_position = global_position
	
	get_node("/root/Global/SoundManager").play(death_sound, false)
	#var stream : AudioStreamPlayer2D = get_node("/root/Global/AudioStreamPlayer2D")
	#stream.stream = death_sound
	#stream.play()
	
	get_parent().queue_free()

func _ready() -> void:
	hero = get_node("/root/Global/hero").get_children(false)[0]
	sprite.play("default")

func _physics_process(delta: float) -> void:
	if hero == null:
		return
	var direction := global_position.direction_to(hero.global_position)
	velocity = direction * SPEED
	sprite.flip_h = velocity.x < 0
		
	move_and_slide()
