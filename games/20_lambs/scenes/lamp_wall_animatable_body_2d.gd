class_name LambsWall
extends AnimatableBody2D

signal position_reset
signal middle_passed

var speed: float = 1000

var original_speed: float

func _ready() -> void:
	original_speed = speed


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position.x -= speed * delta
	
	if position.x <= -400:
		reset_position()


func reset_position() -> void:
	position.y = randf_range(-200, 200)
	position.x = 1400
	emit_signal("position_reset")


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is CharacterBody2D:
		emit_signal("middle_passed")
