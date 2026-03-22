extends Button

@onready var screenshot_node: TextureRect = %screenshot
@onready var score_label: Label = %score_label

var level_packed = PackedScene

@export var screenshot: Texture2D

var score: float = 0

var cam_n: int = 0

func _ready() -> void:
	if screenshot:
		screenshot_node.texture = screenshot
	$cam_label.text = "CAM " + str(cam_n)
	score_label.text = str(int(score))  + "%"

func _on_pressed() -> void:
	#$AudioStreamPlayer2D.play()
	#await $AudioStreamPlayer2D.finished
	if level_packed:
		get_tree().change_scene_to_packed(level_packed)
