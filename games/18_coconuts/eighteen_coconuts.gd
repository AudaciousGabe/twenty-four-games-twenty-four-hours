extends Node


signal game_won

@export var amount_of_coconuts_to_win: int = 18
@export var bird_spawn_delay: float = 0.5

@export var character_body_2d: CharacterBody2D
@export var coconut_spawn_path_2d: Path2D
@export var coconut_spawn_path_follow_2d: PathFollow2D
@export var coconut_rigid_body_2d_scene: PackedScene
@export var coconut_container_node_2d: Node2D
@export var you_win_rich_text_label: RichTextLabel
@export var score_text_rich_text_label: RichTextLabel
@export var bird_spawn_path_2d: Path2D
@export var bird_spawn_path_follow_2d: PathFollow2D
@export var bird_area_2d_scene: PackedScene
@export var bird_container_node_2d: Node2D

var original_character_position: Vector2

var points: int = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	original_character_position = character_body_2d.position


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func die() -> void:
	character_body_2d.position = original_character_position


func drop_coconut() -> void:
	coconut_spawn_path_follow_2d.progress_ratio = randf()
	var coconut: Coconut = coconut_rigid_body_2d_scene.instantiate()
	
	await get_tree().create_timer(0).timeout
	
	coconut_container_node_2d.add_child(coconut)
	coconut.position = coconut_spawn_path_2d.position + coconut_spawn_path_follow_2d.position


func win() -> void:
	you_win_rich_text_label.show()
	emit_signal("game_won")


func take_coconut(coconut: Coconut) -> void:
	coconut.queue_free()
	points += 1
	
	score_text_rich_text_label.text = "[shake level=40]" + str(points)
	
	if points == amount_of_coconuts_to_win:
		win()


func spawn_bird() -> void:
	bird_spawn_path_follow_2d.progress_ratio = randf()
	
	var bird: Bord = bird_area_2d_scene.instantiate()
	bird_container_node_2d.add_child(bird)
	bird.position = bird_spawn_path_2d.position + bird_spawn_path_follow_2d.position
	
	bird.body_entered.connect(_bird_body_entered)



func _bird_body_entered(body: Node2D) -> void:
	if body is CharacterBody2D:
		die()



func _on_bad_terrain_area_2d_body_entered(body: Node2D) -> void:
	die()


func _on_bad_terrain_area_2d_2_body_entered(body: Node2D) -> void:
	die()


func _on_coconut_area_2d_body_entered(body: Node2D) -> void:
	if not body is CharacterBody2D:
		return
	
	drop_coconut()
	


func _on_character_area_2d_body_entered(body: Node2D) -> void:
	if body is Coconut:
		take_coconut(body)


func _on_bird_spawn_timer_timeout() -> void:
	spawn_bird()
