extends Control

@onready var timeLabel = $Label
@onready var countDownTimer = $Timer

@onready var levelManager = $"../../.."

func _process(delta):
	var remainingTime = countDownTimer.time_left
	var minutesAmount = int(remainingTime) / 60
	var secondsAmount = int(remainingTime) % 60
	#timeLabel.text = "%d" % [secondsAmount]
	$"../ProgressBar".value = (remainingTime/$"../../..".getTime())*100
