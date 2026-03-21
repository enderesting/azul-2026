extends Node2D


func _input(event):
	if event is InputEventKey and event.pressed:
		if event.keycode == KEY_R:
			print("Player reset")
			get_tree().reload_current_scene()
