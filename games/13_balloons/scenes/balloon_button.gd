extends Button


@export var y_speed: float = 30.0
@export var x_speed: float = 20.0


var additional_y_speed: float = 0


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	position.y -= ( y_speed + additional_y_speed ) * delta
	position.x += x_speed * delta
	
	
	additional_y_speed += 12.0 * delta
