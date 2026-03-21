extends Line2D

@export var body_points: Array[Node2D] = []

func _process(_delta: float) -> void:
	clear_points()
	for point in body_points:
		if point != null:
			add_point(point.global_position)
