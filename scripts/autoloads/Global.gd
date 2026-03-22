extends Node

signal face_worried
signal face_relaxed
signal face_shook
signal level_begin

var levels := {
	"res://scenes/game_scene/finalLevels/level1.tscn": 0,
	"res://scenes/game_scene/finalLevels/level2.tscn": 0,
	"res://scenes/game_scene/finalLevels/level3.tscn": 0,
	"res://scenes/game_scene/finalLevels/level4.tscn": 0,
	"res://scenes/game_scene/finalLevels/level5.tscn": 0,
	"res://scenes/game_scene/finalLevels/level6.tscn": 0,
	"res://scenes/game_scene/finalLevels/level7.tscn": 0,
	"res://scenes/game_scene/finalLevels/level8.tscn": 0,
	"res://scenes/game_scene/finalLevels/level9.tscn": 0,
}

func save_levels():
	var file = FileAccess.open("user://levels.json", FileAccess.WRITE)
	if file:
		var json_string = JSON.stringify(levels)
		file.store_string(json_string)
		
func load_levels():
	if not FileAccess.file_exists("user://levels.json"):
		return
	
	var file = FileAccess.open("user://levels.json", FileAccess.READ)
	if file:
		var content = file.get_as_text()
		var result = JSON.parse_string(content)
		
		if typeof(result) == TYPE_DICTIONARY:
			levels = result

func reset_levels():
	for key in levels.keys():
		levels[key] = 0
	save_levels()
	print("All scores reset!")

func _ready():
	load_levels()

func get_next_level(current_path: String) -> String:
	var keys = levels.keys()
	var index = keys.find(current_path)
	
	if index == -1:
		return keys[0] # fallback
	
	index += 1
	
	if index >= keys.size():
		index = 0 # loop to first level
	
	return keys[index]

func _unhandled_key_input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed:
		if event.alt_pressed and event.keycode == KEY_R:
			reset_levels()

	if event.is_action_pressed("fullscreen"):
		if DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_FULLSCREEN:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		else:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
