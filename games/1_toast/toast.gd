extends Control

signal game_won

@export var toast_insert_distance: float = 120.0


@export var toast_texture_rect: TextureRect
@export var you_win_panel: Panel

@export var start_toasting_button: Button
@export var eject_button: Button
@export var toasting_progress_bar: ProgressBar
@export var toasting_label: Label

var toasting_speed: float = 2
var toasting_speed_multiplier: float = 0.8
var original_toast_speed_multiplier: float

var toasting: bool = false


func _ready() -> void:
	original_toast_speed_multiplier = toasting_speed_multiplier


func _process(delta: float) -> void:
	if toasting:
		toasting_progress_bar.value += toasting_speed * toasting_speed_multiplier * delta
		toast_texture_rect.modulate.v = lerpf(1.0, 0.3, toasting_progress_bar.value / 100)
		toasting_speed_multiplier += 0.01
		toasting_label.text = str(floor(toasting_progress_bar.value)) + "%"


func start_toasting() -> void:
	toasting_speed_multiplier = original_toast_speed_multiplier
	toasting_progress_bar.value = 0
	eject_button.show()
	start_toasting_button.hide()
	toasting = true
	start_toasting_animation()


func start_toasting_animation() -> void:
	var tween: Tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_ELASTIC)
	tween.tween_property(toast_texture_rect, "position:y", toast_texture_rect.position.y + toast_insert_distance, 2)


func start_ejection_animation() -> void:
	var tween: Tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_ELASTIC)
	tween.tween_property(toast_texture_rect, "position:y", toast_texture_rect.position.y - toast_insert_distance, 1.0)


func eject_toast() -> void:
	toasting = false
	start_ejection_animation()
	eject_button.hide()
	
	if floor(toasting_progress_bar.value) == 69:
		win()
		return
	
	start_toasting_button.show()


func win() -> void:
	print("We Win")
	you_win_panel.show()
	emit_signal("game_won")


func _on_start_toasting_button_pressed() -> void:
	start_toasting()


func _on_eject_button_pressed() -> void:
	eject_toast()
