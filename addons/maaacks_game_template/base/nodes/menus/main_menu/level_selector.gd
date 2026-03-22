extends Control

@onready var menu_container: MarginContainer = %MenuContainer

@export var levels: Array[PackedScene]
@onready var levels_container: GridContainer = $Levels

@export var button_packed: PackedScene

func _on_exit_selector_pressed() -> void:
	hide()
	menu_container.show()

func _ready() -> void:
	for level_path in Global.levels:
		print("A")
		var level_button = button_packed.instantiate()
		level_button.level_packed = load(level_path)
		level_button.score = Global.levels[level_path]
		levels_container.add_child(level_button)
