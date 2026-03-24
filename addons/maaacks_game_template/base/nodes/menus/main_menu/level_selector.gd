extends Control

@onready var menu_container: MarginContainer = %MenuContainer

@export var levels: Array[PackedScene]
@onready var levels_container: GridContainer = $Levels

@export var button_packed: PackedScene

func _on_exit_selector_pressed() -> void:
	hide()
	menu_container.show()

func _ready() -> void:
	var cam_n = 1
	
	for level_path in Global.levels:
		var level_data = Global.levels[level_path]
		
		if typeof(level_data) != TYPE_DICTIONARY:
			level_data = {
				"score": float(level_data),
				"unlocked": level_path == Global.levels.keys()[0]
			}
		Global.levels[level_path] = level_data
		
		var level_button = button_packed.instantiate()
		level_button.level_packed = load(level_path)
		level_button.score = level_data["score"]
		level_button.unlocked = level_data["unlocked"]
		level_button.cam_n = cam_n
		
		levels_container.add_child(level_button)
		cam_n += 1
