extends Node

@export var ball_area_2d: PongBall
@export var score_value_rich_text_label: RichTextLabel
@export var you_win_rich_text_label: RichTextLabel


var points: int = 0
var original_ball_position: Vector2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	original_ball_position = ball_area_2d.position
	reset()

func win() -> void:
	print("You Win")
	ball_area_2d.queue_free()
	score_value_rich_text_label.hide()
	you_win_rich_text_label.show()


func reset() -> void:
	ball_area_2d.speed_multiplier = ball_area_2d.original_speed_multiplier
	ball_area_2d.position = original_ball_position
	score_value_rich_text_label.text = ""
	points = 0
	score_value_rich_text_label.modulate.s = 0


func paddle_hit() -> void:
	points += 1
	
	score_value_rich_text_label.text = "[shake level=" + str(points * 10) + "]" + str(points)
	score_value_rich_text_label.modulate.s = points * 0.1
	
	if points == 11:
		win()
	
	ball_area_2d.speed_multiplier *= 1.13
	

func _on_ball_area_2d_paddle_was_hit() -> void:
	paddle_hit()


func _on_ball_area_2d_dies() -> void:
	reset()
