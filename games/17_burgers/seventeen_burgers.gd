extends Control

signal game_won

@export var amount_of_burgers_to_win: int = 17


@export var burger_layout_scene: PackedScene
@export var burger_layout_h_box_container: HBoxContainer
@export var you_win_rich_text_label: RichTextLabel
@export var score_text_rich_text_label: RichTextLabel


var current_burgers: Array[BurgerLayout]
var points: int = 0


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	spawn_burgers()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func win() -> void:
	you_win_rich_text_label.show()
	emit_signal("game_won")


func spawn_burgers() -> void:
	var burger: BurgerLayout = burger_layout_scene.instantiate()
	
	burger_layout_h_box_container.add_child(burger)
	
	current_burgers.append(burger)
	
	if current_burgers.size() < 4:
		spawn_burgers()
	
	burger.burger_completed.connect(_burger_completed)



func _burger_completed() -> void:
	points += 1
	
	score_text_rich_text_label.text = "[shake level=40]" + str(points)
	
	if points == amount_of_burgers_to_win:
		win()
	
	spawn_burgers()
