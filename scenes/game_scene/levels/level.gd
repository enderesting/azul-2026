extends Node

signal level_lost
signal level_won(level_path : String)
@warning_ignore("unused_signal")
signal level_changed(level_path : String)
@onready var detectionSys = $Detection
@onready var countDownTimer = $"Game UI/VBoxContainer/CountDown/Timer"
@export var time = 15
@export_file("*.tscn") var next_level_path : String
@onready var scanUI = $"AI Scan UI"
@onready var gameUI = $"Game UI"
@onready var ai = $"AI Scan UI/VBoxContainer"
var level_state : LevelState

func _on_lose_button_pressed() -> void:
	level_lost.emit()

func _on_win_button_pressed() -> void:
	level_won.emit(next_level_path)

func resetLevel() -> void:
	get_tree().reload_current_scene()

func _ready() -> void:
	level_state = GameState.get_level_state(scene_file_path)
	countDownTimer.start(time)
	await countDownTimer.timeout
	gameUI.visible = false
	scanUI.visible = true
	await $"AI Scan UI/VBoxContainer".beginScan()
	#detectionSys.showBoxes()
	if detectionSys.checkWinCondition():
		print("win")
		level_won.emit(next_level_path)
	else:
		print("lost")
		resetLevel()
