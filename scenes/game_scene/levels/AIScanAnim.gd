extends VBoxContainer

@onready var warningLabel = $Warning
@onready var codeBlockLabel = $"HBoxContainer/Code Block"
@onready var winloseLog = $HBoxContainer/Log

var maxLines = 5
var terminalLines = []
var logLines = []
var warningMessage = "WARNING: AI scan initialised..."
var fakeLogData = [
	"Loading core drivers...",
	"Super Advanced AI ready",
	"I was told there would be cake",
	"Counting fingers on hands...",
	"Looking for googly eyes...",
	"This is the part where he kills you",
	"Checking sanity...",
	"Playing some Silksong...",
	"Winning Game of the year...",
	".........",
    "Scan complete."
]

func _ready():
	beginScan()

func beginScan():
	warningLabel.text = ""
	codeBlockLabel.text = ""
	winloseLog.text = ""
	await writeWarning()
	await writeTerminalOutput()

func writeWarning():
	var textBuilt = ""
	for i in range(warningMessage.length()):
		textBuilt += warningMessage[i]
		warningLabel.text = textBuilt
		await get_tree().create_timer(0.05).timeout

func writeTerminalOutput():
	for line in fakeLogData:
		terminalLines.append(line)
		if terminalLines.size() > maxLines:
			terminalLines.pop_front()
		
		var currentBlockText = ""
		for i in range(terminalLines.size()):
			currentBlockText += terminalLines[i] + "\n"
			
		codeBlockLabel.text = currentBlockText
		await get_tree().create_timer(0.4).timeout

func get_round_score() -> int:
	return snapped($"../../Detection".getScore(),0.1) * 100

func writeWin():
	var fakeWinLogData = [
		"No issues found",
		"Certainty: %s%%" % str(get_round_score()),
		"Next exhibit"
	]
	winloseLog.modulate = Color("18df13")
	for line in fakeWinLogData:
		var currentBlockText = ""
		for i in range(logLines.size()):
			currentBlockText += logLines[i] + "\n"
		
		var stringBuilder = ""
		for character in line:
			stringBuilder += character
			winloseLog.text = currentBlockText + stringBuilder
			await get_tree().create_timer(0.05).timeout
		
		logLines.append(line)
		if logLines.size() > maxLines:
			logLines.pop_front()
			
	$HBoxContainer/Log/ContinueBtn.visible = true
	$HBoxContainer/Log/MenuBtn.visible = true
	await get_tree().process_frame

func writeLoss():
	var fakeLoseLogData = [
		"ISSUES DETECTED",
		"Match: %s%%" % str(snapped($"../../Detection".getScore(),0.1) * 100),
		"Eliminate TARGET",
		"Continue to be murdered"
	]
	winloseLog.modulate = Color("ff412cff")
	
	for line in fakeLoseLogData:
		var currentBlockText = ""
		for i in range(logLines.size()):
			currentBlockText += logLines[i] + "\n"
		
		var stringBuilder = ""
		for character in line:
			stringBuilder += character
			winloseLog.text = currentBlockText + stringBuilder
			await get_tree().create_timer(0.05).timeout
		
		logLines.append(line)
		if logLines.size() > maxLines:
			logLines.pop_front()
			
	$HBoxContainer/Log/ContinueBtn.visible = true
	$HBoxContainer/Log/MenuBtn.visible = true
	await get_tree().process_frame
