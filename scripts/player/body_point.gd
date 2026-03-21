extends Node2D

@export var neighbours: Array[Node2D] = []
@export var max_dist: float = 60.0
@export var min_dist: float = 30.0

var stiffness: float = 0.5

var dragging := false
var drag_offset := Vector2.ZERO

func _on_button_down():
	dragging = true
	drag_offset = global_position - get_global_mouse_position()

func _on_button_up():
	dragging = false

func _process(_delta):
	if dragging:
		global_position = get_global_mouse_position() + drag_offset
		return
	
	for point in neighbours:
		var direction = global_position - point.global_position
		var distance = direction.length()
		
		if distance > max_dist:
			global_position -= direction.normalized() * (distance - max_dist) * stiffness
		
		if distance < min_dist and distance > 0:
			global_position += direction.normalized() * (min_dist - distance) * stiffness
