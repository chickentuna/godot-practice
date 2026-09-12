class_name Hero extends CharacterBody2D

const BASE_SPEED = 300.0
@onready var sprite = $AnimatedSprite2D
@export var speedMod := 1

func _ready() -> void:
	sprite.play("idle")

func _physics_process(delta: float) -> void:
	
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var xdirection := Input.get_axis("ui_left", "ui_right")
	var ydirection := Input.get_axis("ui_up", "ui_down")
	
	var speed := BASE_SPEED * speedMod
	
	var inputVect := Vector2(xdirection, ydirection)
	
	if inputVect.is_zero_approx():
		sprite.play("idle")
	else:
		sprite.play("move")
	
	if inputVect.is_zero_approx():
		velocity.x = move_toward(velocity.x, 0, BASE_SPEED/2)
		velocity.y = move_toward(velocity.y, 0, BASE_SPEED/2)
		return
	
	inputVect = inputVect.normalized()
	
	velocity.x = inputVect.x * speed
	velocity.y = inputVect.y * speed
	
	if inputVect.x > 0:
		sprite.flip_h = false
	if inputVect.x < 0:
		sprite.flip_h = true
	

	move_and_slide()
