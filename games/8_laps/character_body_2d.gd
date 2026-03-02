class_name IceSkater
extends CharacterBody2D


const SPEED = 10.0
const JUMP_VELOCITY = -400.0


var momentum: float = 0


func _physics_process(delta: float) -> void:
	
	if not is_on_floor():
		velocity += get_gravity() * delta

	if Input.is_action_just_pressed("space") and is_on_floor():
		jump()
		
	
	if Input.is_action_pressed("right"):
		momentum += SPEED
	
	if Input.is_action_pressed("left"):
		momentum -= SPEED
		if momentum <= 0:
			momentum = 0

	velocity.x = momentum
	
	move_and_slide()



func jump() -> void:
	scale.x = 1
	
	velocity.y = JUMP_VELOCITY
	var tween: Tween = create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)
	
	tween.tween_property(self, "scale:x", -1, 0.5)
	tween.tween_property(self, "scale:x", 1, 0.5)
	
	
