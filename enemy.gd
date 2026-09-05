class_name Enemy extends CharacterBody2D

const SPEED = 100
var hero

func _ready() -> void:
	pass

func _physics_process(delta: float) -> void:
	if hero == null:
		hero = get_node("/root/Global/hero").get_children(false)[0]
	var direction := global_position.direction_to(hero.global_position)
	velocity = direction * SPEED
	move_and_slide()
	
#	for i in get_slide_collision_count():
#		var collision = get_slide_collision(i)
#		print("I collided with ", collision.get_collider().name)
