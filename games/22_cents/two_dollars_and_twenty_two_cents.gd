extends Node


signal game_won


enum CoinType {
	PENNY,
	NICKEL,
	DIME,
	QUARTER,
}

@export var spawn_amount: int = 15
@export var spawn_delay: float = 0.3



@export var penny_rigid_body_2d: PackedScene
@export var nickel_rigid_body_2d: PackedScene
@export var dime_rigid_body_2d: PackedScene
@export var quarter_rigid_body_2d: PackedScene

@export var spawn_path_2d: Path2D
@export var spawn_path_follow_2d: PathFollow2D

@export var coin_container_node_2d: Node2D
@export var spawn_coins_button: Button
@export var money_amount_rich_text_label: RichTextLabel
@export var you_win_rich_text_label: RichTextLabel


@onready var coin_values: Array[float] = [
	0.01,
	0.05,
	0.1,
	0.25,
]

@onready var coin_rigid_bodies: Array[PackedScene] = [
	penny_rigid_body_2d,
	nickel_rigid_body_2d,
	dime_rigid_body_2d,
	quarter_rigid_body_2d,
]


var amount_of_money: float = 0.0


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func lose() -> void:
	amount_of_money = 0.0
	money_amount_rich_text_label.text = "[wave]Money Amount: " + str(amount_of_money).pad_decimals(2)
	for coin: RigidBody2D in coin_container_node_2d.get_children():
		coin.queue_free()
	

func win() -> void:
	you_win_rich_text_label.show()
	emit_signal("game_won")


func add_amount(coin_type: CoinType) -> void:
	amount_of_money += coin_values[coin_type]
	if amount_of_money > 2.22:
		lose()
	elif is_equal_approx(amount_of_money, 2.22):
		win()
	
	money_amount_rich_text_label.text = "[wave]Money Amount: " + str(amount_of_money).pad_decimals(2)
	


func spawn_coins() -> void:
	for i: int in spawn_amount:
		var chosen_type: CoinType = CoinType.values().pick_random()
		var coin: RigidBody2D = coin_rigid_bodies[chosen_type].instantiate()
		spawn_path_follow_2d.progress_ratio = randf()
		
		coin_container_node_2d.add_child(coin)
		coin.input_pickable = true
		
		coin.position = spawn_path_follow_2d.position + spawn_path_2d.position
		var button: Button = coin.get_child(-1)
		
		button.pressed.connect(_coin_button_pressed.bind(coin, chosen_type))
		
		await get_tree().create_timer(spawn_delay).timeout
		

func _coin_button_pressed(coin: RigidBody2D, coin_type: CoinType) -> void:
	add_amount(coin_type)
	coin.queue_free()



func _on_spawn_coins_button_pressed() -> void:
	spawn_coins()
