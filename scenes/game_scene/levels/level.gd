extends Node

signal level_lost
@warning_ignore("unused_signal")
@onready var detectionSys = $Detection
@onready var countDownTimer = $"Game UI/VBoxContainer/CountDown/Timer"
@export var time = 20
@export_file("*.tscn") var next_level_path : String
@onready var scanUI = $"AI Scan UI"
@onready var gameUI = $"Game UI"
@onready var ai = $"AI Scan UI/VBoxContainer"
var level_state : LevelState
@onready var animation_player: AnimationPlayer = %AnimationPlayer

@onready var current_level_path = get_scene_file_path()

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
	Global.emit_signal("level_begin")
	$player_anim.play("sneak")
	$Walkie.play()
	animation_player.play_backwards("fade")
	level_state = GameState.get_level_state(scene_file_path)
	await get_tree().create_timer(3.0).timeout
	countDownTimer.start(time)
	await countDownTimer.timeout
	Global.emit_signal("face_shook")
	$Walkie.stop()
	$"Ai Sounds".play()
	$player.canMove = false
	gameUI.visible = false
	detectionSys	.checkBoxes()
	scanUI.visible = true
	await $"AI Scan UI/VBoxContainer".beginScan()
	#detectionSys.showBoxes()
	

	Global.levels[current_level_path] = ai.get_round_score()
	Global.save_levels()
	if detectionSys.checkWinCondition():
		await $"AI Scan UI/VBoxContainer".writeWin()
	else:
		await $"AI Scan UI/VBoxContainer".writeLoss()

func _on_continue_btn_pressed() -> void:
	animation_player.play("fade")
	$NextLvl.play()
	await animation_player.animation_finished


	var next_level = Global.get_next_level(current_level_path)
	get_tree().change_scene_to_file(next_level)



func _on_menu_btn_pressed() -> void:
	animation_player.play("fade")
	$NextLvl.play()
	await animation_player.animation_finished
	get_tree().change_scene_to_file("res://scenes/menus/main_menu/main_menu_with_animations.tscn")


func _on_restart_btn_pressed() -> void:
	resetLevel()
