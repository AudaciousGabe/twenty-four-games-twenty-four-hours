extends Node

@export var laps_to_win: int = 9


@export var spawn_node_2d: Node2D
@export var character_body_2d: IceSkater
@export var icicle_node_2d: Node2D
@export var you_win_rich_text_label: RichTextLabel


var original_position: Vector2

var laps_passed: int = 0


@onready var icicle_indexes: Array[int] = [
	0,
	1,
	2,
	3,
	4,
	5,
	6,
	7,
]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	icicle_indexes.shuffle()
	_connect_signals()
	original_position = character_body_2d.position


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func win() -> void:
	you_win_rich_text_label.show()
	print("You win!")



func add_lap() -> void:
	laps_passed += 1
	
	if laps_passed == laps_to_win:
		win()
		return
	
	add_random_icicle()

func add_random_icicle() -> void:
	
	var icicle: Area2D = icicle_node_2d.get_child(icicle_indexes.pop_front())
	
	icicle.monitoring = true
	icicle.show()
	
	





func character_failed() -> void:
	character_body_2d.momentum = 0
	character_body_2d.position = original_position
	



func reset_character_position() -> void:
	character_body_2d.position = spawn_node_2d.position


func _connect_signals() -> void:
	for i: int in icicle_node_2d.get_child_count():
		var icicle: Area2D = icicle_node_2d.get_child(i)
		icicle.body_entered.connect(_icicle_body_entered)


func _icicle_body_entered(body: Node2D) -> void:
	if body is CharacterBody2D:
		character_failed()


func _on_reset_position_area_2d_body_entered(body: Node2D) -> void:
	if body is CharacterBody2D:
		reset_character_position()
		add_lap()
