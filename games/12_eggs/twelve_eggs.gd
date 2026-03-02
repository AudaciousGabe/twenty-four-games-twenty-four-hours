extends Node


@export var time_to_collect_all_eggs: float = 31.0
@export var amount_of_eggs: int = 12


@export var character_area_2d: Area2D
@export var spawn_reference_rect: ReferenceRect
@export var egg_area_2d_scene: PackedScene
@export var eggs_container_node_2d: Node2D
@export var start_button: Button
@export var detector_color_rect: ColorRect
@export var timer: Timer
@export var timer_rich_text_label: RichTextLabel
@export var no_text_rich_text_label: RichTextLabel
@export var you_win_rich_text_label: RichTextLabel


var eggs: Array[Egg] = []


var collected_eggs: int = 0
var good_egg: Egg
var hunting: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("space"):
		if character_area_2d.get_overlapping_areas():
			grab_closest_egg()
	timer.time_left


func start_detector_animation() -> void:
	if not good_egg:
		return
	
	while hunting:
		var scale_of_detector_color_rect: float = (get_distance_from_good_egg() + 2.0) / 200
		var scale_of_detector_color_rect_vector_2 := Vector2(scale_of_detector_color_rect, scale_of_detector_color_rect)
		
		var tween: Tween = create_tween().set_loops().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_ELASTIC)
		tween.tween_property(detector_color_rect, "scale", scale_of_detector_color_rect_vector_2, 1)
		
		await get_tree().create_timer(.3).timeout

func get_distance_from_good_egg() -> float:
	if not good_egg:
		return 0.0
	
	return character_area_2d.global_position.distance_to(good_egg.position)


func spawn_eggs() -> void:
	
	for i: int in amount_of_eggs:
		var egg: Egg = egg_area_2d_scene.instantiate()
		eggs.append(egg)
		eggs_container_node_2d.add_child(egg)
		egg.position.x = randf_range(spawn_reference_rect.position.x, spawn_reference_rect.position.x + spawn_reference_rect.size.x)
		egg.position.y = randf_range(spawn_reference_rect.position.y, spawn_reference_rect.position.y + spawn_reference_rect.size.y)
		egg.modulate = Color(randf(), randf(), randf())
		egg.modulate.v = 1.0
	
	eggs.shuffle()
	
	good_egg = eggs.pop_back()
	
	good_egg.modulate = Color.BLACK
	

func grab_closest_egg() -> void:
	
	var closest_area: Area2D
	
	for area: Area2D in character_area_2d.get_overlapping_areas():
		if not closest_area:
			closest_area = area
			break
		
		var closest_area_distance: float = closest_area.global_position.distance_to(character_area_2d.global_position)
		var new_area_distance: float = area.global_position.distance_to(character_area_2d.global_position)
		
		if new_area_distance < closest_area_distance:
			closest_area = area
	
	check_if_correct_egg(closest_area)
	good_egg = eggs.pop_back()

func start() -> void:
	hunting = true
	spawn_eggs()
	start_detector_animation()
	start_button.hide()
	no_text_rich_text_label.hide()


func win() -> void:
	print("You Win")
	you_win_rich_text_label.show()


func lose() -> void:
	collected_eggs = 0
	
	for egg: Egg in eggs_container_node_2d.get_children():
		egg.queue_free()
	
	eggs.clear()
	start_button.show()
	no_text_rich_text_label.show()
	
	timer_rich_text_label.text = "[wave amp=40]" + str(collected_eggs)

func collect_egg(egg: Egg) -> void:
	collected_eggs += 1
	
	timer_rich_text_label.text = "[wave amp=40]" + str(collected_eggs)
	
	if collected_eggs == amount_of_eggs:
		win()
	
	


func check_if_correct_egg(egg: Egg) -> void:
	if egg == good_egg:
		collect_egg(egg)
	else:
		lose()
	
	egg.queue_free()


func _on_start_button_pressed() -> void:
	start()
