extends Node

signal game_won

@export var points_to_win: int = 21


@export var preview_ball_sprite_2d: Sprite2D
@export var basket_ball_rigid_body_2d_scene: PackedScene
@export var ball_container_node_2d: Node2D
@export var animatable_body_2d: AnimatableBody2D
@export var hoop_container_node_2d: Node2D
@export var score_text_rich_text_label: RichTextLabel
@export var you_win_rich_text_label: RichTextLabel


var points: int = 0
var speed_multiplier: float = 1.0


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	animate_hoop()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if preview_ball_sprite_2d.get_global_mouse_position().x < 800:
		preview_ball_sprite_2d.hide()
		return
	
	if preview_ball_sprite_2d.get_global_mouse_position().y > 100:
		preview_ball_sprite_2d.hide()
		return
	
	preview_ball_sprite_2d.show()
	preview_ball_sprite_2d.position = preview_ball_sprite_2d.get_global_mouse_position()


func win() -> void:
	print("Test")
	you_win_rich_text_label.show()
	emit_signal("game_won")


func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if not event.pressed:
				spawn_ball(event.position)


func animate_hoop() -> void:
	
	while true:
	
		var tween: Tween = create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CIRC)
		
		tween.tween_property(animatable_body_2d, "position:y", animatable_body_2d.position.y + 300, 2.0)
		tween.tween_property(animatable_body_2d, "position:y", animatable_body_2d.position.y, 2.0)
		
		var tween_x: Tween = create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CIRC)
		
		tween_x.tween_property(hoop_container_node_2d, "position:x", hoop_container_node_2d.position.x + 250, 1.4)
		tween_x.tween_property(hoop_container_node_2d, "position:x", hoop_container_node_2d.position.x, 1.4)
		
		await tween.finished
		
func spawn_ball(spawn_position: Vector2) -> void:
	
	var basket_ball: RigidBody2D = basket_ball_rigid_body_2d_scene.instantiate()
	
	ball_container_node_2d.add_child(basket_ball)
	
	basket_ball.position = spawn_position


func _on_hoop_area_2d_body_entered(body: Node2D) -> void:
	if not body is BasketBall:
		return
	
	points += 1
	score_text_rich_text_label.text = "[shake level=40]" + str(points)
	
	
	if points == points_to_win:
		win()
