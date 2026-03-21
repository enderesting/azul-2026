extends Node

signal level_lost
@warning_ignore("unused_signal")
@onready var detectionSys = $Detection
@onready var countDownTimer = $"Game UI/VBoxContainer/CountDown/Timer"
@export var time = 15
@export_file("*.tscn") var next_level_path : String
@onready var scanUI = $"AI Scan UI"
@onready var gameUI = $"Game UI"
@onready var ai = $"AI Scan UI/VBoxContainer"
var level_state : LevelState

func resetLevel() -> void:
	get_tree().reload_current_scene()

func _ready() -> void:
	level_state = GameState.get_level_state(scene_file_path)
	countDownTimer.start(time)
	await countDownTimer.timeout
	$player.canMove = false
	gameUI.visible = false
	scanUI.visible = true
	await $"AI Scan UI/VBoxContainer".beginScan()
	#detectionSys.showBoxes()
	if detectionSys.checkWinCondition():
		get_tree().change_scene_to_file(next_level_path)
	else:
		resetLevel()
