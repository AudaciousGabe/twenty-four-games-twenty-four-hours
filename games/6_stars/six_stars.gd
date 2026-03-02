extends Control

@export var spawn_delay: float = 1
@export var star_speed: float = 3.0

var stars_pressed: int = 0


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass





func _star_button_pressed() -> void:
	stars_pressed += 1
