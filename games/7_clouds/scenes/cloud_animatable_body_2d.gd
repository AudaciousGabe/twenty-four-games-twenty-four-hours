class_name Cloud
extends AnimatableBody2D


var path_2D: CloudPath
var path_follow_2D: PathFollow2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if not path_2D or not path_follow_2D:
		return
	
	position = path_follow_2D.position + path_2D.position
