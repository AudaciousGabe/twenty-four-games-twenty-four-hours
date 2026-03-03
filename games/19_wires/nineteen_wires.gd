extends Control

signal game_won

@export var amount_of_wires_to_spawn: int = 19
@export var wires_h_box_container: HBoxContainer
@export var wires_h_box_container_2: HBoxContainer
@export var you_win_rich_text_label: RichTextLabel

@export var wire_button_scene: PackedScene

var colors_to_pick_from: Array[String] = [
	"be4a2f",
	"d77643",
	"ead4aa",
	"e4a672",
	"b86f50",
	"733e39",
	"3e2731",
	"a22633",
	"e43b44",
	"f77622",
	"feae34",
	"fee761",
	"63c74d",
	"3e8948",
	"265c42",
	"193c3e",
	"124e89",
	"0099db",
	"2ce8f5",
	"ffffff",
	"c0cbdc",
	"8b9bb4",
	"5a6988",
	"3a4466",
	"262b44",
	"181425",
	"ff0044",
	"68386c",
	"b55088",
	"f6757a",
	"e8b796",
	"c28569",
]

var points: int = 0
var current_colors: Array[Color]
var previous_pressed_button: Button

func _ready() -> void:
	get_random_colored_wires()
	setup_second_wires()


func win() -> void:
	you_win_rich_text_label.show()
	emit_signal("game_won")


func get_random_colored_wires() -> void:
	var colors_to_pick_from_dupe: Array[String] = colors_to_pick_from.duplicate()
	colors_to_pick_from_dupe.shuffle()
	
	for i: int in amount_of_wires_to_spawn:
		var wire_button: Button = wire_button_scene.instantiate()
		var color: Color = Color.html(colors_to_pick_from.pop_back())
		
		current_colors.append(color)
		
		wire_button.modulate = color
		wires_h_box_container.add_child(wire_button)
		
		wire_button.pressed.connect(_wire_button_pressed.bind(wire_button))
	
func setup_second_wires() -> void:
	var current_colors_dupe: Array[Color] = current_colors.duplicate()
	
	current_colors_dupe.shuffle()
	
	for color: Color in current_colors_dupe:
		var wire_button: Button = wire_button_scene.instantiate()
		wire_button.modulate = color
		
		wires_h_box_container_2.add_child(wire_button)
		
		wire_button.pressed.connect(_wire_button_pressed.bind(wire_button))
		

func fade_button_pair(first_button: Button, second_button: Button) -> void:
	
	for button: Button in [first_button, second_button]:
		button.disabled = false
		
		var tween: Tween = create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CIRC)
		tween.tween_property(button, "modulate", Color.GREEN, 0.2)
		tween.tween_property(button, "modulate", Color.TRANSPARENT, 1.0)


func _wire_button_pressed(button: WireButton) -> void:
	if not previous_pressed_button:
		previous_pressed_button = button
		button.color_rect.show()
		return
	
	if button.modulate == previous_pressed_button.modulate:
		button.color_rect.show()
		fade_button_pair(previous_pressed_button, button)
		previous_pressed_button = null
		points += 1
		
		if points == amount_of_wires_to_spawn:
			win()
