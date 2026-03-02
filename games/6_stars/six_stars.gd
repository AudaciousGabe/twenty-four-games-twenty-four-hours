extends Control

@export var spawn_delay: float = 0.3
@export var star_speed: float = 3.0
@export var stars_to_win: int = 6


@export var star_button_scene: PackedScene
@export var star_control: Control
@export var spawn_timer: Timer
@export var score_number_rich_text_label: RichTextLabel
@export var you_win_rich_text_label: RichTextLabel

var stars_pressed: int = 0

@export var spawn_reference_rect: ReferenceRect

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	spawn_timer.start(spawn_delay)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func spawn_star() -> void:
	var spawn_pos_y: float = randf_range(spawn_reference_rect.position.y, spawn_reference_rect.position.y + spawn_reference_rect.size.y)
	
	var star: Button = star_button_scene.instantiate()
	star_control.add_child(star)
	star.position.y = spawn_pos_y
	star.position.x = spawn_reference_rect.position.x
	
	var random_color: Color = Color(randf(), randf(), randf())
	
	star.modulate = random_color
	
	star.pressed.connect(_star_button_pressed.bind(star))


func win() -> void:
	you_win_rich_text_label.show()


func _star_button_pressed(star: Button) -> void:
	star.queue_free()
	stars_pressed += 1
	
	if stars_pressed == stars_to_win:
		win()
	
	score_number_rich_text_label.text = str(stars_pressed)


func _on_spawn_timer_timeout() -> void:
	spawn_star()
