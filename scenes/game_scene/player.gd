extends Node2D

var canMove = true
var currentTopZIndex = 1

func _input(event):
	if event is InputEventKey and event.pressed:
		if event.keycode == KEY_R:
			print("Player reset")
			get_tree().reload_current_scene()
