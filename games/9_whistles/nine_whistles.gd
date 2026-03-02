extends Control


@export var timing_delta: float = 0.07
@export var score_to_win: int = 9


@export var whistle_song_audio_stream_player: AudioStreamPlayer
@export var reset_song_timer: Timer
@export var color_rect_h_box_container: HBoxContainer
@export var blowing_texture_rect: TextureRect
@export var not_blowing_texture_rect: TextureRect
@export var score_number_rich_text_label: RichTextLabel
@export var you_win_rich_text_label: RichTextLabel


@onready var correct_timings: Array[float] = [
	2.51,
	1.8,
	1.1,
]


var current_index_in_sequence: int = 0
var good_timing_streak: int = 0

var score: int = 0


func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if not event.pressed:
				return
			
			print(reset_song_timer.time_left)
			check_if_timing_is_correct()



func win() -> void:
	you_win_rich_text_label.show()
	reset_song_timer.stop()


func good_timing() -> void:
	good_timing_streak += 1
	color_rect_in_sequence(Color.GREEN)
	blow_whistle_animation()
	
	if good_timing_streak == 3:
		score += 3
		score_number_rich_text_label.text = str(score)
		
		if score >= 9:
			win()


func bad_timing() -> void:
	color_rect_in_sequence(Color.RED)
	blow_whistle_animation()


func blow_whistle_animation(bad_timing: bool = false) -> void:
	blowing_texture_rect.show()
	not_blowing_texture_rect.hide()
	
	if bad_timing:
		pass
	
	await get_tree().create_timer(0.3).timeout
	
	blowing_texture_rect.hide()
	not_blowing_texture_rect.show()
	
	if bad_timing:
		pass
	

func color_rect_in_sequence(color: Color) -> void:
	if current_index_in_sequence + 1 > color_rect_h_box_container.get_child_count():
		return
	
	var color_rect: ColorRect = color_rect_h_box_container.get_child(current_index_in_sequence)
	
	color_rect.color = color


func check_if_timing_is_correct() -> void:
	for timing: float in correct_timings:
		if reset_song_timer.time_left >= timing - timing_delta:
			if reset_song_timer.time_left <= timing + timing_delta:
				good_timing()
				break
			else:
				bad_timing()
		else:
			bad_timing()
	
	current_index_in_sequence += 1


func reset_color_rect_colors() -> void:
	for color_rect: ColorRect in color_rect_h_box_container.get_children():
		color_rect.color = Color.WHITE


func _on_reset_song_timer_timeout() -> void:
	whistle_song_audio_stream_player.play()
	current_index_in_sequence = 0
	reset_color_rect_colors()
	good_timing_streak = 0
	
