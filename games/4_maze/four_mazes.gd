extends Control



@export var first_maze_texture_rect: TextureRect
@export var cursor_sprite_2d: Sprite2D


var current_maze_index: int = 0

var maze_attempt_started: bool = false

@onready var maze_texture_rects: Array[TextureRect] = [
	first_maze_texture_rect,
]


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	cursor_sprite_2d.position = cursor_sprite_2d.get_global_mouse_position()



func is_mouse_position_color_transparent(mouse_position: Vector2) -> bool:
	var current_maze: TextureRect = get_current_maze()
	var current_maze_texture: AnimatedTexture = current_maze.texture
	var first_current_maze_texture: Texture2D = current_maze_texture.get_frame_texture(current_maze_texture.current_frame)
	var current_maze_image: Image = first_current_maze_texture.get_image()
	var mouse_color: Color = current_maze_image.get_pixelv(mouse_position)
	
	if mouse_color == Color.TRANSPARENT:
		return true

	return false

func get_current_maze() -> TextureRect:
	return maze_texture_rects[current_maze_index]


func _on_maze_texture_rect_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		print("Position: ", event.position)
		print(is_mouse_position_color_transparent(event.position))
