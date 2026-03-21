extends Node

signal level_lost
@warning_ignore("unused_signal")
@onready var detectionSys = $Detection
@onready var countDownTimer = $"Game UI/VBoxContainer/CountDown/Timer"
@export var time = 18
@export_file("*.tscn") var next_level_path : String
@onready var scanUI = $"AI Scan UI"
@onready var gameUI = $"Game UI"
@onready var ai = $"AI Scan UI/VBoxContainer"
var level_state : LevelState
@onready var animation_player: AnimationPlayer = %AnimationPlayer

func getTime():
	return time

func resetLevel() -> void:
	get_tree().reload_current_scene()
	
func setBrightness(targetValue : float) -> void:
	$CanvasLayer2/ColorRect.material.set_shader_parameter("brightness", targetValue)

func fadeBrightness(targetValue : float, duration : float) -> void:
	var tween = get_tree().create_tween()
	var startValue = $CanvasLayer2/ColorRect.material.get_shader_parameter("brightness")
	tween.tween_method(setBrightness, startValue, targetValue, duration)
	await tween.finished

func _ready() -> void:
	animation_player.play_backwards("fade")
	level_state = GameState.get_level_state(scene_file_path)
	countDownTimer.start(time)
	await countDownTimer.timeout
	$player.canMove = false
	gameUI.visible = false
	detectionSys	.checkBoxes()
	scanUI.visible = true
	await $"AI Scan UI/VBoxContainer".beginScan()
	#detectionSys.showBoxes()
	if detectionSys.checkWinCondition():
		await $"AI Scan UI/VBoxContainer".writeWin()
		animation_player.play("fade")
		await animation_player.animation_finished
		get_tree().change_scene_to_file(next_level_path)
	else:
		await $"AI Scan UI/VBoxContainer".writeLoss()
		animation_player.play("fade")
		await animation_player.animation_finished
		resetLevel()

#func _exit_tree() -> void:
#	animation_player.play("fade")
