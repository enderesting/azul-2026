extends Control

@onready var timeLabel = $Label
@onready var countDownTimer = $Timer

func _process(delta):
	var remainingTime = countDownTimer.time_left
	var minutesAmount = int(remainingTime) / 60
	var secondsAmount = int(remainingTime) % 60
	timeLabel.text = "%d" % [secondsAmount]
