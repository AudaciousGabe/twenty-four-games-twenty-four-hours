class_name BalloonButton
extends Button


signal color_balloon_pressed(color: Color, button: Button)


@export var y_speed: float = 30.0
@export var x_speed: float = 20.0


var colors: Array[Color] = [
	Color.AQUA,
	Color.CHARTREUSE,
	Color.CRIMSON,
	Color.FUCHSIA,
	Color.WEB_PURPLE,
	Color.ORANGE,
	Color.YELLOW,
]


var additional_y_speed: float = 0


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	position.y -= ( y_speed + additional_y_speed ) * delta
	position.x += x_speed * delta
	
	additional_y_speed += 12.0 * delta


func _on_timer_timeout() -> void:
	modulate = colors.pick_random()


func _on_pressed() -> void:
	emit_signal("color_balloon_pressed", modulate, self)
