extends CharacterBody2D

@export var sprite_2d: Sprite2D


const SPEED = 500.0
const JUMP_VELOCITY = -400.0


func _physics_process(delta: float) -> void:
	
	var direction := Input.get_axis("left", "right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	
	var direction_y := Input.get_axis("up", "down")
	if direction_y:
		velocity.y = direction_y * SPEED
	else:
		velocity.y = move_toward(velocity.y, 0, SPEED)
	
	if Input.is_action_just_pressed("left"):
		sprite_2d.flip_h = true
	elif Input.is_action_just_pressed("right"):
		sprite_2d.flip_h = false
	
	
	move_and_slide()
