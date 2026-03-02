extends CharacterBody2D

@export var sprint_speed_multiplier: float = 2.0

const SPEED = 300.0
const JUMP_VELOCITY = -400.0


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("space") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	
	var new_speed: float = SPEED
	
	if Input.is_action_pressed("shift"):
		new_speed *= sprint_speed_multiplier
	
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you shvar direction := Input.get_axis("left", "right")
	if direction:
		velocity.x = direction * new_speed
	else:
		velocity.x = move_toward(velocity.x, 0, new_speed)ould replace UI actions with custom gameplay actions.
	

	move_and_slide()
