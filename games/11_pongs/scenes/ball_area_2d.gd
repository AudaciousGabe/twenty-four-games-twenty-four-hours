class_name PongBall
extends Area2D

signal dies()
signal paddle_was_hit()

@export var speed_x: float = 60.0
@export var speed_y: float = 40.0

@export var original_speed_multiplier: float = 8.0

var going_left: bool = false
var going_up: bool = false

@onready var speed_multiplier: float = original_speed_multiplier

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var new_speed_x: float = speed_x
	var new_speed_y: float = speed_y
	
	if going_up:
		new_speed_y = -new_speed_y
	
	if going_left:
		new_speed_x = -new_speed_x
	
	
	position.x += new_speed_x * delta * speed_multiplier
	position.y += new_speed_y * delta * speed_multiplier


func _on_body_entered(body: Node2D) -> void:
	going_up = !going_up


func _on_area_entered(area: Area2D) -> void:
	if area is Paddle:
		going_left = !going_left
		speed_y = randf_range(10, 120)
		emit_signal("paddle_was_hit")
	else:
		emit_signal("dies")
