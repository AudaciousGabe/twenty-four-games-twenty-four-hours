extends Button


var position_delta: float

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	position_delta = randf_range(-500, 500)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	rotation_degrees += 1000 * delta
	position.x += 1800 * delta
	position.y += position_delta * delta
