extends Control


@export var time_to_win: float = 21.0
@export var move_distance: float = 5.0

@export var left_slime_margin_container: MarginContainer
@export var timer: Timer
@export var timer_label: Label


var original_left_slime_position: Vector2
var original_right_slime_position: Vector2


var game_started: bool = false


func _ready() -> void:
	original_left_slime_position = left_slime_margin_container.position


func _process(_delta: float) -> void:
	timer_label.text = str(floor(timer.time_left))


func move_left_slime() -> void:
	left_slime_margin_container.position.x += move_distance


func start() -> void:
	timer.start(time_to_win)


func win() -> void:
	pass


func _on_area_2d_area_entered(_area: Area2D) -> void:
	win()


func _on_left_slime_button_pressed() -> void:
	if not game_started:
		start()
		game_started = true
	move_left_slime()
