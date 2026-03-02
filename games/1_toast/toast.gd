extends Control


@export var start_toasting_button: Button
@export var eject_button: Button


func _ready() -> void:
	pass # Replace with function body.


func _process(delta: float) -> void:
	pass


func start_toasting() -> void:
	eject_button.show()
	start_toasting_button.hide()


func eject_toast() -> void:
	pass


func _on_start_toasting_button_pressed() -> void:
	start_toasting()


func _on_eject_button_pressed() -> void:
	pass # Replace with function body.
