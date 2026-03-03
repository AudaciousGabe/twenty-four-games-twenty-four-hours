extends Control

signal game_won

@export var amount_of_balloons_to_pop: int = 13


@export var balloon_button_scene: PackedScene
@export var spawn_path_2d: Path2D
@export var spawn_path_follow_2d: PathFollow2D
@export var balloon_button_control: Control
@export var timer: Timer
@export var you_win_rich_text_label: RichTextLabel
@export var score_text_rich_text_label: RichTextLabel
@export var audio_stream_player: AudioStreamPlayer


var points: int = 0


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func spawn_balloon() -> void:
	spawn_path_follow_2d.progress_ratio = randf()
	
	var balloon: BalloonButton = balloon_button_scene.instantiate()
	
	balloon_button_control.add_child(balloon)
	
	balloon.position = spawn_path_2d.position + spawn_path_follow_2d.position
	
	balloon.color_balloon_pressed.connect(_balloon_button_pressed)


func win() -> void:
	you_win_rich_text_label.show()
	
	emit_signal("game_won")

func pop_balloon() -> void:
	points += 1
	score_text_rich_text_label.text = "[shake level=40]" + str(points) + " Yellow Balloons"
	
	if points == amount_of_balloons_to_pop:
		win()

func lose_points() -> void:
	points -= 3
	score_text_rich_text_label.text = "[shake level=40]" + str(points) + " Yellow Balloons"


func _balloon_button_pressed(color: Color, button: Button) -> void:
	if color == Color.YELLOW:
		pop_balloon()
	else:
		lose_points()
	
	button.queue_free()
	
	audio_stream_player.play()


func _on_timer_timeout() -> void:
	spawn_balloon()
