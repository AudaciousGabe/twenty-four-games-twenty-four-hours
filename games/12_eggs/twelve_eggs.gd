extends Node

@export var amount_of_eggs: int = 12


@export var character_area_2d: Area2D
@export var spawn_reference_rect: ReferenceRect
@export var egg_area_2d_scene: PackedScene
@export var eggs_container_node_2d: Node2D
@export var start_button: Button


var collected_eggs: int = 0
var good_egg: Egg


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("space"):
		if character_area_2d.get_overlapping_areas():
			grab_closest_egg()


func spawn_eggs() -> void:
	
	for i: int in amount_of_eggs:
		var egg: Egg = egg_area_2d_scene.instantiate()
		
		eggs_container_node_2d.add_child(egg)
		egg.position.x = randf_range(spawn_reference_rect.position.x, spawn_reference_rect.position.x + spawn_reference_rect.size.x)
		egg.position.y = randf_range(spawn_reference_rect.position.y, spawn_reference_rect.position.y + spawn_reference_rect.size.y)



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

func start() -> void:
	spawn_eggs()
	start_button.hide()

func lose() -> void:
	start_button.show()


func collect_egg() -> void:
	collected_eggs += 1


func check_if_correct_egg(egg: Egg) -> void:
	if egg == good_egg:
		collect_egg()
	else:
		lose()


func _on_start_button_pressed() -> void:
	start()
