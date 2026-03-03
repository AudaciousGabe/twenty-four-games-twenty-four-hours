extends Control

signal game_won

@export var letters_h_box_container: HBoxContainer
@export var typing_letter_scene: PackedScene
@export var you_win_rich_text_label: RichTextLabel


var words_to_type: Array[String] = [
	"twenty",
	"three",
	"words",
	"to",
	"type",
	"hiii",
	"thanks",
	"time",
	"community",
	"care",
	"effort",
	"sweetness",
	"presense",
	"reoccurance",
	"thought",
	"laughter",
	"fun",
	"support",
	"friendship",
	"smoochies",
	"love",
	"audacious",
	"uhbyechat"
]


var current_word: String
var current_typing_letters: Array[TypingLetter]
var current_letters: Array[String]
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	start_next_word()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _input(event: InputEvent) -> void:
	if event is InputEventKey:
		if not event.pressed:
			return
		check_if_key_is_next_letter(event.as_text_key_label())


func win() -> void:
	you_win_rich_text_label.show()
	var tween: Tween = create_tween()
	tween.tween_property(letters_h_box_container, "modulate", Color.TRANSPARENT, 0.5)
	emit_signal("game_won")


func check_if_key_is_next_letter(letter: String) -> void:
	if current_letters[0].to_lower() == letter.to_lower():
		current_letters.pop_front()
		current_typing_letters.pop_front().letter_typed()
		
		if current_typing_letters.is_empty():
			
			if words_to_type.is_empty():
				win()
			else:
				start_next_word()


func start_next_word() -> void:
	if letters_h_box_container.get_child_count():
		var tween: Tween = create_tween()
		
		tween.tween_property(letters_h_box_container, "modulate", Color.TRANSPARENT, 0.5)
		await tween.finished
		
		for child: Control in letters_h_box_container.get_children():
			child.queue_free()
	
	var tween: Tween = create_tween()
		
	tween.tween_property(letters_h_box_container, "modulate", Color.WHITE, 0.5)
	
	
	current_word = words_to_type.pop_front()
	
	for letter: String in current_word:
		current_letters.append(letter)
		
		var typing_letter: TypingLetter = typing_letter_scene.instantiate()
		letters_h_box_container.add_child(typing_letter)
		
		typing_letter.assign_letter(letter)
		current_typing_letters.append(typing_letter)
