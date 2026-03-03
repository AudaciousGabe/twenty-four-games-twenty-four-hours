extends Node
@export var scenes_node: Node
@export var color_rect: ColorRect

@export var toast_scene: PackedScene
@export var two_slimes_scene: PackedScene
@export var three_pancakes_scene: PackedScene
@export var four_mazes_scene: PackedScene
@export var five_petals_scene: PackedScene
@export var six_stars_scene: PackedScene
@export var seven_clouds_scene: PackedScene
@export var eight_laps_scene: PackedScene
@export var nine_whistles_scene: PackedScene
@export var ten_damage_scene: PackedScene
@export var eleven_pongs_scene: PackedScene
@export var twelve_eggs_scene: PackedScene
@export var thirdteen_balloons_scene: PackedScene
@export var fourteen_toppings_scene: PackedScene
@export var fifteen_blocks_scene: PackedScene
@export var sixteen_munchies_scene: PackedScene
@export var seventeen_burgers_scene: PackedScene
@export var eighteen_coconuts_scene: PackedScene
@export var nineteen_wires_scene: PackedScene
@export var twenty_lambs_scene: PackedScene
@export var tweenty_one_hoops_scene: PackedScene
@export var two_dollars_and_twenty_two_cents_scene: PackedScene
@export var twenty_three_words_scene: PackedScene
@export var bonus_scene_scene: PackedScene


var last_scene: Node
var current_scene_index: int = 0

@onready var scenes: Array[PackedScene] = [
	toast_scene,
	two_slimes_scene,
	three_pancakes_scene,
	four_mazes_scene,
	five_petals_scene,
	six_stars_scene,
	seven_clouds_scene,
	eight_laps_scene,
	nine_whistles_scene,
	ten_damage_scene,
	eleven_pongs_scene,
	twelve_eggs_scene,
	thirdteen_balloons_scene,
	fourteen_toppings_scene,
	fifteen_blocks_scene,
	sixteen_munchies_scene,
	seventeen_burgers_scene,
	eighteen_coconuts_scene,
	nineteen_wires_scene,
	twenty_lambs_scene,
	tweenty_one_hoops_scene,
	two_dollars_and_twenty_two_cents_scene,
	twenty_three_words_scene,
	bonus_scene_scene,
]



func _ready() -> void:
	load_next_scene()



func load_next_scene() -> void:
	var tween: Tween = create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)
	tween.tween_property(color_rect, "color", Color.BLACK, 1.0)
	
	await tween.finished
	
	
	var next_scene: Node = scenes[current_scene_index].instantiate()
	
	if last_scene:
		last_scene.queue_free()
	
	last_scene = next_scene
	
	scenes_node.add_child(next_scene)
	
	next_scene.game_won.connect(load_next_scene)
	
	current_scene_index += 1
	
	var tween_two: Tween = create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)
	tween_two.tween_property(color_rect, "color", Color(0, 0, 0, 0), 1.0)
	
