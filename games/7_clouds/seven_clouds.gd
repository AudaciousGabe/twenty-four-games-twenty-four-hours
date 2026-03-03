extends Node

signal game_won

@export var cloud_path_2d: Path2D
@export var cloud_path_2d_2: Path2D
@export var cloud_path_2d_3: Path2D
@export var cloud_path_2d_4: Path2D
@export var cloud_path_2d_5: Path2D
@export var cloud_path_2d_6: Path2D
@export var cloud_path_2d_7: Path2D
@export var clouds_container_node_2d: Node2D
@export var you_win_rich_text_label: RichTextLabel

@export var cloud_animatable_body_2d_scene: PackedScene

const AMOUNT_OF_CLOUDS: int = 7

var clouds: Array[AnimatableBody2D] = []


@onready var cloud_paths: Array[CloudPath] = [
	cloud_path_2d,
	cloud_path_2d_2,
	cloud_path_2d_3,
	cloud_path_2d_4,
	cloud_path_2d_5,
	cloud_path_2d_6,
	cloud_path_2d_7,
]





# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	setup_clouds()
	setup_paths()



func setup_clouds() -> void:
	for i: int in AMOUNT_OF_CLOUDS:
		var cloud: Cloud = cloud_animatable_body_2d_scene.instantiate()
		cloud.path_2D = cloud_paths[i]
		cloud.path_follow_2D = cloud.path_2D.path_follow_2d
		
		clouds_container_node_2d.add_child(cloud)



func setup_paths() -> void:
	for path: CloudPath in cloud_paths:
		var i: int = cloud_paths.find(path)
		path.speed = 10 * ( i + 1 )
		path.path_follow_2d.progress_ratio = randf()
		

func win() -> void:
	you_win_rich_text_label.show()
	emit_signal("game_won")


func _on_lolipop_area_2d_body_entered(body: Node2D) -> void:
	win()
