extends Node

signal game_won

@export var blocks_to_stack_to_win: int = 15


@export var block_rigid_body_2d_scene: PackedScene
@export var block_container_node_2d: Node2D
@export var preview_block_sprite_2d: Sprite2D
@export var winning_timer: Timer
@export var you_win_rich_text_label: RichTextLabel
@export var score_text_rich_text_label: RichTextLabel
@export var winning_timer_text_rich_text_label: RichTextLabel

var block_rotated: bool = false

var points: int = 0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	preview_block_sprite_2d.position = preview_block_sprite_2d.get_global_mouse_position()
	winning_timer_text_rich_text_label.text = str(floorf(winning_timer.time_left))

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if not event.pressed:
				return
			spawn_block()

func win() -> void:
	print("Yay")
	you_win_rich_text_label.show()
	emit_signal("game_won")


func start_winning() -> void:
	winning_timer_text_rich_text_label.show()
	winning_timer.start(6)
	
	await winning_timer.timeout
	
	if points == blocks_to_stack_to_win:
		win()
	
	winning_timer_text_rich_text_label.hide()
	


func spawn_block() -> void:
	var block: Block = block_rigid_body_2d_scene.instantiate()
	
	block_container_node_2d.add_child(block)
	
	block.position = block_container_node_2d.get_global_mouse_position()
	
	if block_rotated:
		block.rotation_degrees += 90
	
	block.touched_floor.connect(_block_touched_floor)
	
	if randi_range(0, 1):
		rotate_next_block()
	
	points += 1
	
	score_text_rich_text_label.text = "[shake level=40]" + str(points)
	
	if points == blocks_to_stack_to_win:
		start_winning()


func rotate_next_block() -> void:
	if block_rotated:
		block_rotated = false
		preview_block_sprite_2d.rotation_degrees += 90
	else:
		block_rotated = true
		preview_block_sprite_2d.rotation_degrees -= 90


func lose() -> void:
	for blocks: Block in block_container_node_2d.get_children():
		blocks.queue_free()
	
	points = 0
	score_text_rich_text_label.text = "[shake level=40]" + str(points)
	
	winning_timer_text_rich_text_label.hide()


func _block_touched_floor() -> void:
	lose()
