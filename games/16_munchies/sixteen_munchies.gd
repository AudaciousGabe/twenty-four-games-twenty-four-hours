extends Node


signal game_won

@export var amount_of_munchies: int = 16
@export var growth_increase: float = 0.4

@export var monster_animatable_body_2d: AnimatableBody2D
@export var spawn_reference_rect: ReferenceRect
@export var spawn_reference_rect_2: ReferenceRect
@export var munchy_rigid_body_2d_scene: PackedScene
@export var munchy_container_node_2d: Node2D
@export var you_win_rich_text_label: RichTextLabel

var points: int = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	await get_tree().create_timer(0).timeout
	spawn_munchies()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	monster_animatable_body_2d.position = monster_animatable_body_2d.get_global_mouse_position()


func win() -> void:
	you_win_rich_text_label.show()
	emit_signal("game_won")


func spawn_munchies() -> void:
	
	var scale := Vector2(0.1, 0.1)
	
	var munchies: Array[Munchy]
	
	for i: int in amount_of_munchies:
		var munchy: Munchy = munchy_rigid_body_2d_scene.instantiate()
		var coin_flip: bool = randi_range(0, 1)
		var spawn_rect: ReferenceRect
		
		if coin_flip:
			spawn_rect = spawn_reference_rect
		else:
			spawn_rect = spawn_reference_rect_2
		
		munchy.position.x = randf_range(spawn_rect.position.x, spawn_rect.position.x + spawn_rect.size.x )
		munchy.position.y = randf_range(spawn_rect.position.y, spawn_rect.position.y + spawn_rect.size.y )
		
		munchy.scale = Vector2.ZERO
		munchy.scale += scale
		
		scale += Vector2(0.1, 0.1)
		
		munchies.append(munchy)
	
	munchies.reverse()
	
	for munchy: Munchy in munchies:
		munchy_container_node_2d.add_child(munchy)
	
	

func attempt_to_munch(munchy: Munchy) -> void:
	if not munchy.scale <= monster_animatable_body_2d.scale:
		return
	monster_animatable_body_2d.scale += Vector2(0.1, 0.1)
	points += 1
	
	if points == amount_of_munchies:
		win()
	
	munchy.queue_free()



func _on_monster_area_2d_area_entered(area: Area2D) -> void:
	if area is Munchy:
		attempt_to_munch(area)
