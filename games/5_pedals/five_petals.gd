extends Control

enum PetalColor {
	RED,
	BLUE,
	PURPLE,
	ORANGE,
	PINK,
}


@export var amount_of_rounds: int = 5
@export var sequence_length_seconds: float = 0.3

@export var red_button: Button
@export var blue_button: Button
@export var purple_button: Button
@export var orange_button: Button
@export var pink_button: Button
@export var start_button: Button

@export var you_win_rich_text_label: RichTextLabel

@export var color_sequence_h_box_container: HBoxContainer
@export var no_text_rich_text_label: RichTextLabel

@export var click_audio_stream_player: AudioStreamPlayer

var color_sequence: Array[PetalColor]
var color_sequence_current_length: int = 1
var current_sequence_index: int = 0

var current_round_index: int = 0

@onready var color_buttons: Array[Button] = [
	red_button,
	blue_button,
	purple_button,
	orange_button,
	pink_button,
]


var colors: Array[Color] = [
	Color.html("ea323c"), 
	Color.html("00cdf9"),
	Color.html("93388f"),
	Color.html("ffaf1d"),
	Color.html("db3ffd"),
]


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_connect_signals()


func reset_color_sequence() -> void:
	color_sequence.clear()


func add_color_to_sequence() -> void:
	color_sequence.append(PetalColor.values().pick_random())


func start() -> void:
	reset_color_sequence()
	go_next_round()
	
	start_button.hide()
	no_text_rich_text_label.hide()
	
	for button: Button in color_buttons:
		button.disabled = false


func win() -> void:
	for button: Button in color_buttons:
		button.disabled = true
	
	you_win_rich_text_label.show()
	print("You win!")


func lost() -> void:
	print("Lost")
	current_round_index = 0
	
	start_button.show()
	no_text_rich_text_label.show()
	
	for button: Button in color_buttons:
		button.disabled = true


func animate_sequence() -> void:
	
	for petal: PetalColor in color_sequence:
		var button: Button = color_buttons[petal]
		var tween: Tween = create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CIRC)
	
		tween.tween_property(button, "modulate:a", 1.0 , sequence_length_seconds )
		tween.tween_property(button, "modulate:a", 0.5, sequence_length_seconds )
		
		await tween.finished


func go_next_round() -> void:
	if current_round_index == amount_of_rounds:
		win()
		return
	
	current_round_index += 1
	current_sequence_index = 0
	
	
	add_color_to_sequence()
	
	await get_tree().create_timer(1).timeout
	
	animate_sequence()
	


func go_next_in_sequence() -> void:
	current_sequence_index += 1
	
	if color_sequence.size() == current_sequence_index:
		go_next_round()
		return
	


func check_if_next_color_in_sequence(petal_color: PetalColor) -> void:
	
	
	if color_sequence[current_sequence_index] == petal_color:
		go_next_in_sequence()
		click_audio_stream_player.pitch_scale = randf_range(0.7, 1.3)
		click_audio_stream_player.play()
	else:
		lost()



func _connect_signals() -> void:
	for i: int in color_buttons.size():
		var button: Button = color_buttons[i]
		button.pressed.connect(_color_button_pressed.bind(PetalColor.values()[i]))


func _color_button_pressed(petal_color: PetalColor) -> void:
	check_if_next_color_in_sequence(petal_color)
	print(petal_color)


func _on_start_button_pressed() -> void:
	start()
