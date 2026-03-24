extends Node

signal face_worried
signal face_relaxed
signal face_shook
signal level_begin

#if you increase this number all pcs with old saves will have their saves reset
const SAVE_VERSION = 2

var levels = {
	"res://scenes/game_scene/finalLevels/level1.tscn": {
		"score": 0,
		"unlocked": true
	},
	"res://scenes/game_scene/finalLevels/level2.tscn": {
		"score": 0,
		"unlocked": false
	},
	"res://scenes/game_scene/finalLevels/level3.tscn": {
		"score": 0,
		"unlocked": false
	},
	"res://scenes/game_scene/finalLevels/level4.tscn": {
		"score": 0,
		"unlocked": false
	},
	"res://scenes/game_scene/finalLevels/level5.tscn": {
		"score": 0,
		"unlocked": false
	},
	"res://scenes/game_scene/finalLevels/level6.tscn": {
		"score": 0,
		"unlocked": false
	},
	"res://scenes/game_scene/finalLevels/level7.tscn": {
		"score": 0,
		"unlocked": false
	},
	"res://scenes/game_scene/finalLevels/level8.tscn": {
		"score": 0,
		"unlocked": false
	},
	"res://scenes/game_scene/finalLevels/level9.tscn": {
		"score": 0,
		"unlocked": false
	}
}

func save_levels():
	var file = FileAccess.open("user://levels.json", FileAccess.WRITE)
	if file:
		var data = {
			"version": SAVE_VERSION,
			"levels": levels
		}
		file.store_string(JSON.stringify(data))
		
func load_levels():
	if not FileAccess.file_exists("user://levels.json"):
		return
	
	var file = FileAccess.open("user://levels.json", FileAccess.READ)
	if file:
		var content = file.get_as_text()
		var result = JSON.parse_string(content)
		
		if typeof(result) == TYPE_DICTIONARY:
			
			if not result.has("version") or result["version"] != SAVE_VERSION:
				reset_levels()
				return
			
			if result.has("levels"):
				for key in result["levels"].keys():
					if levels.has(key):
						levels[key] = result["levels"][key]

func reset_levels():
	if FileAccess.file_exists("user://levels.json"):
		DirAccess.remove_absolute("user://levels.json")
	for key in levels.keys():
		levels[key] = 0
	save_levels()

func cheat_unlock_all():
	for key in levels.keys():
		levels[key]["score"] = 100
		levels[key]["unlocked"] = true
	save_levels()
	get_tree().reload_current_scene()


func _ready():
	load_levels()

func get_next_level(current_path: String) -> String:
	var keys = levels.keys()
	var index = keys.find(current_path)
	
	if index == -1:
		return keys[0]
	
	index += 1
	
	if index >= keys.size():
		return ""
	
	return keys[index]

func _unhandled_key_input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed:
		if event.alt_pressed and event.keycode == KEY_R:
			reset_levels()
	
		if event.alt_pressed and event.keycode == KEY_U:
			cheat_unlock_all()

	if event.is_action_pressed("fullscreen"):
		if DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_FULLSCREEN:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		else:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
