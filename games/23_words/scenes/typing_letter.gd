class_name TypingLetter
extends MarginContainer

@export var rich_text_label: RichTextLabel

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func assign_letter(letter: String) -> void:
	rich_text_label.text = "[wave]" + letter

func letter_typed() -> void:
	modulate = Color.GREEN
