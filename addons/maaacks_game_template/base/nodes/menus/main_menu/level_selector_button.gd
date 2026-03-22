extends Button

@onready var screenshot_node: TextureRect = %screenshot

@export var level_packed = PackedScene

@export var screenshot: Texture2D

func _ready() -> void:
	if screenshot:
		screenshot_node.texture = screenshot

func _on_pressed() -> void:
	$AudioStreamPlayer2D.play()
	await $AudioStreamPlayer2D.finished
	get_tree().change_scene_to_packed(level_packed)
