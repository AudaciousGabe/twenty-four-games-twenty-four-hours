extends Node

signal game_won

@export var points_to_win: int = 20

@export var character_body_2d: CharacterBody2D

@export var lamp_wall_animatable_body_2d: LambsWall
@export var score_text_rich_text_label: RichTextLabel
@export var you_win_rich_text_label: RichTextLabel

var points: int = 0

var original_lamb_position: Vector2


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	original_lamb_position = character_body_2d.position


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func win() -> void:
	you_win_rich_text_label.show()
	emit_signal("game_won")


func reset() -> void:
	points = 0
	score_text_rich_text_label.text = "[shake level=40]" + str(points)
	
	character_body_2d.position = original_lamb_position
	lamp_wall_animatable_body_2d.speed = lamp_wall_animatable_body_2d.original_speed


func _on_lamp_wall_animatable_body_2d_position_reset() -> void:
	pass


func _on_lamp_wall_animatable_body_2d_middle_passed() -> void:
	lamp_wall_animatable_body_2d.speed *= 1.02
	points += 1
	
	score_text_rich_text_label.text = "[shake level=40]" + str(points)
	
	if points == points_to_win:
		win()


func _on_death_area_2d_body_entered(body: Node2D) -> void:
	if body is CharacterBody2D:
		reset()
