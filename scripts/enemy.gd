class_name Enemy extends CharacterBody2D
@onready var sprite = $AnimatedSprite2D
var dust_scene = preload("res://scenes/dust.tscn")
var coin_scene = preload("res://scenes/coin.tscn")

var death_sound: AudioStream = preload("res://sounds/death.wav")
@onready var health_display_node: Node2D = $healthbar
@onready var progress_bar: TextureProgressBar = $healthbar/ProgressBar

const SPEED = 100
var hero

var max_health : int
var health : int

func get_hit() -> void:
	health -= 10
	health_display_node.visible = true
	progress_bar.value = (float(health) / float(max_health)) * 100
	if health <= 0:
		# spawn dust
		var dust := dust_scene.instantiate()
		get_node("/root").add_child(dust)
		dust.global_position = global_position
		
		# spawn coin
		var coin := coin_scene.instantiate()
		get_node("/root/Global/Coins").add_child(coin)
		coin.global_position = global_position
		
		# die
		get_node("/root/Global/SoundManager").play(death_sound, false)
		get_parent().queue_free()

func _ready() -> void:
	hero = get_node("/root/Global/hero").get_children(false)[0]
	sprite.play("default")
	health = max_health
	

func _physics_process(delta: float) -> void:
	if hero == null:
		return
	
	var target : Vector2 = hero.global_position
	var goal_direction := global_position.direction_to(target)
	var direction_steer_away_other := Vector2(randf_range(-1,1),randf_range(-1,1))
	
	var direction = (goal_direction * 2 + direction_steer_away_other).normalized()
	
	if not direction.is_zero_approx():
		direction = direction.normalized()
	velocity = direction * SPEED
	var flip_threshold := 70
	
	if sprite.flip_h and velocity.x > flip_threshold:
		print(velocity.x)
		sprite.flip_h = false
	elif not sprite.flip_h and velocity.x < -flip_threshold:
		sprite.flip_h = true
		
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
