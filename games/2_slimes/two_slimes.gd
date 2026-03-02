extends Control


@export var time_to_win: float = 21.0
@export var move_distance: float = 15.0

@export var left_slime_margin_container: MarginContainer
@export var right_slime_margin_container: MarginContainer
@export var timer: Timer
@export var timer_label: Label
@export var left_slime_button: Button
@export var right_slime_button: Button
@export var blanket_control: Control
@export var start_button: Button
@export var you_win_rich_text_label: RichTextLabel


var original_left_slime_position: Vector2
var original_right_slime_position: Vector2


var game_started: bool = false


func _ready() -> void:
	original_left_slime_position = left_slime_margin_container.position


func _process(_delta: float) -> void:
	timer_label.text = str(int(floor(timer.time_left)))


func move_left_slime() -> void:
	left_slime_margin_container.position.x += move_distance


func move_right_slime() -> void:
	right_slime_margin_container.position.x -= move_distance


func start() -> void:
	timer.start(time_to_win)
	show_random_button()
	start_button.hide()


func win() -> void:
	timer.stop()
	timer_label.hide()
	you_win_rich_text_label.show()
	print("You Win!")


func lose() -> void:
	start_button.show()
	left_slime_button.hide()
	right_slime_button.hide()


func show_random_button() -> void:
	var coin_flip: int = randi_range(0, 1)
	
	if coin_flip == 0:
		left_slime_button.show()
		right_slime_button.hide()
	else:
		left_slime_button.hide()
		right_slime_button.show()


func _on_area_2d_area_entered(_area: Area2D) -> void:
	win()
	left_slime_button.hide()
	right_slime_button.hide()
	blanket_control.show()


func _on_left_slime_button_pressed() -> void:
	if not game_started:
		start()
		game_started = true
	
	move_left_slime()
	show_random_button()


func _on_right_slime_button_pressed() -> void:
	if not game_started:
		start()
		game_started = true
	
	move_right_slime()
	show_random_button()


func _on_timer_timeout() -> void:
	lose()


func _on_start_button_pressed() -> void:
	start()
