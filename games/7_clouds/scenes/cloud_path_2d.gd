class_name CloudPath
extends Path2D

@export var path_follow_2d: PathFollow2D
@export var speed: float = 10
@export var speed_multiplier: float = 0.01


var move_right: bool = false


func _ready() -> void:
	pass # Replace with function body.


func _process(delta: float) -> void:
	if move_right:
		path_follow_2d.progress_ratio += speed * delta * speed_multiplier
	else:
		path_follow_2d.progress_ratio -= speed * delta * speed_multiplier
	
	if path_follow_2d.progress_ratio >= 1.0:
		move_right = false
	
	if path_follow_2d.progress_ratio <= 0.0:
		move_right = true
