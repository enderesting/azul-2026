extends VBoxContainer

@onready var warningLabel = $Warning
@onready var codeBlockLabel = $"Code Block"

var maxLines = 5
var terminalLines = []
var warningMessage = "WARNING: AI scan initialised..."
var fakeLogData = [
	"Loading core drivers...",
	"Super Advanced AI ready",
	"Looking for googly eyes...",
	"Checking sanity...",
	"Playing some Silksong...",
	"Winning Game of the year...",
	".........",
	"Counting fingers on hands...",
    "Scan complete."
]

func _ready():
	warningLabel.text = ""
	codeBlockLabel.text = ""
	beginScan()

func beginScan():
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
