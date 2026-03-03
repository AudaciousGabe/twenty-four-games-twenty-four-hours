class_name BurgerLayout
extends PanelContainer


signal burger_completed


enum Ingredients {
	TOP_BUN,
	MAYO,
	KETCHUP,
	PICKLES,
	TOMATO,
	LETTUCE,
	CHEESE,
	BURGER,
	BOTTOM_BUN,
}

@export var burger_cook_time: float = 3
@export var completion_fade_time: float = 1.0

@export var burger_timer_rich_text_label: RichTextLabel
@export var burger_cook_timer: Timer

@export var top_bun_button: Button
@export var mayo_button: Button
@export var ketchup_button: Button
@export var pickles_button: Button
@export var lettuce_button: Button
@export var tomato_button: Button
@export var cheese_button: Button
@export var burger_button: Button
@export var bottom_bun_button: Button
@export var recipe_v_box_container: VBoxContainer


var recipe: Array[Ingredients] = []


@onready var ingredient_buttons: Array[Button] = [
	top_bun_button,
	mayo_button,
	ketchup_button,
	pickles_button,
	tomato_button,
	lettuce_button,
	cheese_button,
	burger_button,
	bottom_bun_button,
]


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_connect_signals()
	create_random_burg()


func _process(_delta: float) -> void:
	burger_timer_rich_text_label.text = "[shake]" + str(int(floor(burger_cook_timer.time_left)))


func create_random_burg() -> void:
	recipe.append(Ingredients.TOP_BUN)
	top_bun_button.show()
	
	if randi_range(0, 1):
		recipe.append(Ingredients.MAYO)
		mayo_button.show()
	if randi_range(0, 1):
		recipe.append(Ingredients.KETCHUP)
		ketchup_button.show()
	if randi_range(0, 2):
		recipe.append(Ingredients.PICKLES)
		pickles_button.show()
	if randi_range(0, 2):
		recipe.append(Ingredients.TOMATO)
		tomato_button.show()
	if randi_range(0, 2):
		recipe.append(Ingredients.LETTUCE)
		lettuce_button.show()
	if randi_range(0, 3):
		recipe.append(Ingredients.CHEESE)
		cheese_button.show()
	if randi_range(0, 4):
		recipe.append(Ingredients.BURGER)
		burger_button.show()
	
	recipe.append(Ingredients.BOTTOM_BUN)
	bottom_bun_button.show()
	
	create_recipe_labels()


func create_recipe_labels() -> void:
	for ingredient: Ingredients in recipe:
		var rich_text_label := RichTextLabel.new()
		rich_text_label.text += "[wave]"
		rich_text_label.text += get_ingredient_string(ingredient).capitalize()
		rich_text_label.fit_content = true
		rich_text_label.bbcode_enabled = true
		recipe_v_box_container.add_child(rich_text_label)


static func get_ingredient_string(ingredient: Ingredients) -> String:
	return Ingredients.keys()[ingredient]


func completed_burger() -> void:
	var tween: Tween = create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CIRC)
	
	tween.tween_property(self, "modulate", Color.GREEN, completion_fade_time / 2)
	tween.tween_property(self, "modulate", Color.TRANSPARENT, completion_fade_time / 2)
	
	await tween.finished
	
	emit_signal("burger_completed")
	queue_free()

func add_ingredient(ingredient: Ingredients) -> void:
	recipe.pop_back()
	
	if ingredient == Ingredients.TOP_BUN:
		completed_burger()
		return
	
	if ingredient == Ingredients.BURGER:
		burger_timer_rich_text_label.show()
		burger_cook_timer.start(burger_cook_time)
		await burger_cook_timer.timeout
	
		
	
	var next_ingredient_button: Button = ingredient_buttons[recipe[-1]]
	next_ingredient_button.disabled = false



func _connect_signals() -> void:
	for i: int in ingredient_buttons.size():
		var button: Button = ingredient_buttons[i]
		button.pressed.connect(_ingredient_button_pressed.bind(Ingredients.values()[i], button))



func _ingredient_button_pressed(ingredient: Ingredients, button: Button) -> void:
	add_ingredient(ingredient)
	button.disabled = true
	
	
