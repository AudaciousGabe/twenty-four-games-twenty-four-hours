class_name Topping
extends Area2D

@export var cherry_sprite_2d: Sprite2D
@export var banana_sprite_2d: Sprite2D
@export var chocolate_sprite_2d: Sprite2D
@export var collision_shape_2d: CollisionShape2D

var ingredient: FourteenToppings.Ingredients
var moving: bool = true
var attach_delta: Vector2
var attach_node: Node2D

var additional_y_movement: float = 20


@onready var ingredient_sprites: Array[Sprite2D] = [
	cherry_sprite_2d,
	banana_sprite_2d,
	chocolate_sprite_2d,
]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	ingredient = FourteenToppings.Ingredients.values().pick_random()
	
	ingredient_sprites[ingredient].show()
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if not moving:
		attach()
	
	position.y += ( 300 + additional_y_movement ) * delta
	additional_y_movement += 10 * delta



func attach() -> void:
	position = attach_node.position - attach_delta
