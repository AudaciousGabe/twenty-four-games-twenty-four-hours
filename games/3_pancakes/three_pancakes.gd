extends Node


@export var position_x_delta: float = 5.0
@export var amount_pancakes_to_spawn: int = 3

@export var cursor_collision_animatable_body_2d: AnimatableBody2D
@export var pancake_rigid_body_2d: PackedScene
@export var pancakes_container_node_2d: Node2D
@export var spawn_path_2d: Path2D
@export var spawn_path_follow_2d: PathFollow2D
@export var pancake_rigid_body_2d_scene: PackedScene
@export var you_win_rich_text_label: RichTextLabel


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	start()


func _process(delta: float) -> void:
	cursor_collision_animatable_body_2d.position = cursor_collision_animatable_body_2d.get_global_mouse_position()


func start() -> void:
	if not pancakes_container_node_2d.get_child_count() == 0:
		for pancake: Node2D in pancakes_container_node_2d.get_children():
			pancake.queue_free()
	
	spawn_multiple_pancakes(amount_pancakes_to_spawn)


func spawn_multiple_pancakes(amount: int) -> void:
	for i: int in amount:
		spawn_pancake()


func spawn_pancake() -> void:
	spawn_path_follow_2d.progress_ratio = randf()
	
	var pancake: RigidBody2D = pancake_rigid_body_2d_scene.instantiate()
	
	pancake.position = spawn_path_follow_2d.position + spawn_path_2d.position
	pancake.rotation_degrees = randf_range(0, 360)
	pancakes_container_node_2d.add_child(pancake)


func check_if_pancakes_are_stacked() -> bool:
	if pancakes_container_node_2d.get_child_count() == 0:
		return false
	
	var pancake_x_positions: Array[float]
	var min_x_position: float
	var max_x_position: float
	
	for pancake: RigidBody2D in pancakes_container_node_2d.get_children():
		pancake_x_positions.append(pancake.position.x)
	
	min_x_position = min(pancake_x_positions[0], pancake_x_positions[1], pancake_x_positions[2])
	max_x_position = max(pancake_x_positions[0], pancake_x_positions[1], pancake_x_positions[2])
	
	if max_x_position - min_x_position <= position_x_delta:
		return true
	
	return false


func win() -> void:
	you_win_rich_text_label.show()
	print("You Win!")


func _on_start_button_pressed() -> void:
	start()


func _on_check_if_pancakes_are_stacked_button_pressed() -> void:
	if check_if_pancakes_are_stacked():
		win()
