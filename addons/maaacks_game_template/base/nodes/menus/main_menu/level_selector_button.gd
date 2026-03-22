extends Button


@export var level_packed = PackedScene



func _on_pressed() -> void:
	$"../../../AudioStreamPlayer2D".play()
	get_tree().change_scene_to_packed(level_packed)
