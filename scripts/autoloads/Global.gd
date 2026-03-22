extends Node
signal face_worried
signal face_relaxed

var levels := {
	"res://scenes/game_scene/finalLevels/level1.tscn": 0,
	"res://scenes/game_scene/finalLevels/level2.tscn": 0,
	"res://scenes/game_scene/finalLevels/level3.tscn": 0,
	"res://scenes/game_scene/finalLevels/level4.tscn": 0,
	"res://scenes/game_scene/finalLevels/level5.tscn": 0,
	"res://scenes/game_scene/finalLevels/level6.tscn": 0
}

func _unhandled_key_input(event: InputEvent) -> void:
	if event.is_action_pressed("fullscreen"):
		if DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_FULLSCREEN:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		else:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
