class_name FourteenToppings
extends Node

signal game_won

enum Ingredients {
	CHERRY,
	BANANA,
	CHOCOLATE,
}

@export var recipe_length: int = 14
@export var spawn_delay: float = 0.3
@export var recipe_v_box_container: VBoxContainer
@export var topping_rigid_body_2d_scene: PackedScene
@export var spawn_path_2d: Path2D
@export var spawn_path_follow_2d: PathFollow2D
@export var ingredient_spawn_timer: Timer
@export var ingredients_container_node_2d: Node2D
@export var toppings_area_2d: Area2D
@export var you_win_rich_text_label: RichTextLabel
@export var score_text_rich_text_label: RichTextLabel


var recipe: Array[Ingredients]
var points: int = 0


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	ingredient_spawn_timer.start(spawn_delay)
	create_recipe()


func _process(delta: float) -> void:
	toppings_area_2d.position = toppings_area_2d.get_global_mouse_position()

func win() -> void:
	you_win_rich_text_label.show()
	emit_signal("game_won")


func create_recipe() -> void:
	recipe.clear()
	
	for i: int in recipe_length:
		recipe.append(Ingredients.values().pick_random())
	
	update_recipe_list()

func update_recipe_list() -> void:
	for label: Label in recipe_v_box_container.get_children():
		label.queue_free()
	
	for topping: Ingredients in recipe:
		var label := Label.new()
		recipe_v_box_container.add_child(label)
		label.text = Ingredients.keys()[topping].capitalize()


func spawn_ingredient() -> void:
	spawn_path_follow_2d.progress_ratio = randf()
	
	var topping: Topping = topping_rigid_body_2d_scene.instantiate()
	
	ingredients_container_node_2d.add_child(topping)
	topping.position = spawn_path_2d.position + spawn_path_follow_2d.position


func lose() -> void:
	create_recipe()
	for topping: Topping in ingredients_container_node_2d.get_children():
		topping.queue_free()
	points = 0
	score_text_rich_text_label.text = "[shake level=40]" + str(points)

func check_ingredient() -> void:
	update_recipe_list()
	points += 1
	score_text_rich_text_label.text = "[shake level=40]" + str(points)
	
	if points == recipe_length:
		win()



func check_if_next_ingredient_on_recipe(ingredient: Ingredients) -> void:
	if not recipe.size():
		return
	
	var next_ingredient: Ingredients = recipe.pop_front()
	
	if next_ingredient == ingredient:
		check_ingredient()
	else:
		lose()


func _on_ingredient_spawn_timer_timeout() -> void:
	spawn_ingredient()


func _on_toppings_area_2d_area_entered(area: Area2D) -> void:
	if area is Topping:
		check_if_next_ingredient_on_recipe(area.ingredient)
		area.moving = false
		area.attach_delta = toppings_area_2d.position - area.position
		area.attach_node = toppings_area_2d
