extends Line2D

@export var body_points: Array[Node2D] = []

func _enter_tree() -> void:
	if name != "Neck":
		add_to_group("dynamicLines")

func _process(_delta: float) -> void:
	clear_points()
	for point in body_points:
		if point != null:
			add_point(point.position)

func adjustZIndex(grabbedJoint: Node2D, topZ: int) -> void:
	if grabbedJoint in body_points:
		z_index = topZ
	else:
		z_index = max(z_index-1,0)
