extends Control


enum Type {
	DAMAGE,
	HEALING,
	SHIELD,
}


@export var amount_of_abilities_drawn: int = 5
@export var amount_of_actions: int = 2
@export var enemy_turn_length_seconds: float = 3.0

@export var enemy_health_value_rich_text_label: RichTextLabel
@export var start_button: Button

@export var buttons_h_box_container: HBoxContainer
@export var crit_text_rich_text_label: RichTextLabel
@export var player_health_value_rich_text_label: RichTextLabel
@export var damage_received_text_rich_text_label: RichTextLabel
@export var player_shield_rich_text_label: RichTextLabel
@export var lost_text_rich_text_label: RichTextLabel
@export var you_win_rich_text_label: RichTextLabel

var player_health: int = 10
var player_shield: int = 0
var enemy_health: int = 10
var enemy_shield: int = 2

var actions_used: int = 0


var ded: bool = false
var won: bool = false

func _ready() -> void:
	pass # Replace with function body.


func _process(delta: float) -> void:
	pass


func generate_ability_button() -> void:
	var button := Button.new()
	
	buttons_h_box_container.add_child(button)
	
	var type: Type = Type.values().pick_random()
	var value: int
	
	match type:
		Type.DAMAGE:
			value = randi_range(1, 4)
		Type.HEALING:
			value = randi_range(1, 3)
		Type.SHIELD:
			value = randi_range(1, 6)
	
	button.text = Type.keys()[type] + ": " + str(value)
	
	button.pressed.connect(_ability_button_pressed.bind(type, value, button))


func win() -> void:
	print("You Win")
	won = true
	you_win_rich_text_label.show()


func damage_enemy(damage_amount: int) -> void:
	if damage_amount <= enemy_shield:
		return
	
	damage_amount -= enemy_shield
	enemy_shield = 0
	enemy_health -= damage_amount
	
	if enemy_health <= 0:
		enemy_health = 0
		win()
	
	enemy_health_value_rich_text_label.text = str(enemy_health)


func apply_healing(healing_amount: int) -> void:
	player_health += healing_amount
	player_health_value_rich_text_label.text = str(player_health)
	


func start() -> void:
	ded = false
	enemy_health = 10
	player_health = 10
	player_shield = 0
	start_button.hide()
	draw_abilities()
	lost_text_rich_text_label.hide()
	remove_abilities()



func remove_abilities() -> void:
	for button: Button in buttons_h_box_container.get_children():
		button.queue_free()


func draw_abilities() -> void:
	actions_used = 0
	
	if buttons_h_box_container.get_child_count() > 0:
		remove_abilities()

	for i: int in amount_of_abilities_drawn:
		generate_ability_button()

func lose() -> void:
	print("Game Over")
	start_button.text = "Reset"
	start_button.show()
	lost_text_rich_text_label.show()


func receive_damage(damage_amount: int) -> void:
	if damage_amount < player_shield:
		apply_shield(-damage_amount)
	else:
		player_health -= damage_amount - player_shield
		player_shield = 0
		apply_shield(-player_shield)
	
	if player_health <= 0:
		lose()
	
	
	player_health_value_rich_text_label.text = str(player_health)
	damage_received_text_rich_text_label.show()
	damage_received_text_rich_text_label.text = "[shake level=40]Damage: " + str(damage_amount)
	
	await get_tree().create_timer(enemy_turn_length_seconds).timeout
	damage_received_text_rich_text_label.hide()


func apply_shield(shield_amount: int) -> void:
	
	player_shield += shield_amount
	
	player_shield_rich_text_label.text = "[pulse]" + str(player_shield) + " Shield"
	


func apply_ability(type: Type, value: int) -> void:
	
	match type:
		Type.DAMAGE:
			damage_enemy(value)
		Type.HEALING:
			apply_healing(value)
		Type.SHIELD:
			apply_shield(value)

func show_landed_crit_animation() -> void:
	crit_text_rich_text_label.show()
	await get_tree().create_timer(enemy_turn_length_seconds).timeout
	crit_text_rich_text_label.hide()


func start_enemy_turn() -> void:
	var landed_crit: bool = false if randi_range(0, 1) == 0 else true
	var damage_multiplier: int = 1
	
	if landed_crit:
		damage_multiplier = 2
		show_landed_crit_animation()
	
	receive_damage(randi_range(2, 5) * damage_multiplier)
	
	enemy_shield = 2
	
	await get_tree().create_timer(enemy_turn_length_seconds).timeout
	
	start_player_turn()


func start_player_turn() -> void:
	if ded or won:
		return
	
	apply_shield(-player_shield)
	draw_abilities()


func _ability_button_pressed(type: Type, value: int, button: Button) -> void:
	apply_ability(type, value)
	button.disabled = true
	
	actions_used += 1
	
	if actions_used >= amount_of_actions:
		remove_abilities()
		start_enemy_turn()
	


func _on_start_button_pressed() -> void:
	start()
