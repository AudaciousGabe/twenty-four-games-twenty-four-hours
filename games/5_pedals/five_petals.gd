extends Control

enum PetalColor {
	RED,
	BLUE,
	PURPLE,
	ORANGE,
	PINK,
}


@export var amount_of_rounds: int = 5


@export var red_button: Button
@export var blue_button: Button
@export var purple_button: Button
@export var orange_button: Button
@export var pink_button: Button


@export var color_sequence_h_box_container: HBoxContainer


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
	Color.html("ff5000"),
	Color.html("db3ffd"),
]


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_connect_signals()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func reset_color_sequence() -> void:
	color_sequence.clear()
	
	var pedal_colors: Array[PetalColor] = PetalColor.values()
	pedal_colors.shuffle()
	
	for i: int in pedal_colors:
		if i >= color_sequence_current_length:
			return
		
		color_sequence.append(pedal_colors[i])


func start() -> void:
	go_next_round()


func win() -> void:
	print("You win!")


func lost() -> void:
	current_round_index = 0



func go_next_round() -> void:
	current_round_index += 1
	
	


func go_next_in_sequence() -> void:
	current_sequence_index += 1
	
	if color_sequence.size() == current_sequence_index:
		go_next_round()


func check_if_next_color_in_sequence(petal_color: PetalColor) -> void:
	if color_sequence[current_sequence_index] == petal_color:
		go_next_in_sequence()
	else:
		lost()



func _connect_signals() -> void:
	for i: int in color_buttons.size():
		var button: Button = color_buttons[i]
		button.pressed.connect(_color_button_pressed.bind([PetalColor.values()[i]]))


func _color_button_pressed(petal_color: PetalColor) -> void:
	check_if_next_color_in_sequence(petal_color)


func _on_start_button_pressed() -> void:
	start()
