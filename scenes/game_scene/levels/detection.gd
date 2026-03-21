extends Node2D

@export var trigger_distance: float = 200.0
@export var show_debug_visuals: bool = true

var body_parts: Array[Node] = []
var target_nodes: Array[Node] = []

var distances: Dictionary = {
	"Head": 200.0, "L_Hand": 200.0, "R_Hand": 200.0, "L_Foot": 200.0, "R_Foot": 200.0
}

var match_coefficient: float = 0.0

func _ready() -> void:
	body_parts = get_tree().get_nodes_in_group("player_points")
	target_nodes = get_children()
	
	if show_debug_visuals:
		_setup_target_visuals(target_nodes)
		_setup_target_visuals(body_parts)

func _setup_target_visuals(target_nodes: Array[Node]) -> void:
	for target in target_nodes:
		if not target is Node2D: continue
		
		var rect = ReferenceRect.new()
		rect.size = Vector2(60, 60) 
		rect.position = -rect.size / 2 
		rect.border_color = Color.GREEN
		rect.border_width = 2.0
		rect.editor_only = false 
		target.add_child(rect)
		target.move_child(rect, 0)
		
		var label = Label.new()
		label.text = target.name
		label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		label.position = Vector2(-50, -rect.size.y / 2 - 25)
		label.custom_minimum_size = Vector2(100, 20)
		target.add_child(label)
		target.move_child(label, 0)

func _process(_delta: float) -> void:
	for key in distances.keys():
		distances[key] = trigger_distance

	for target in target_nodes:
		if not target is Node2D: continue
		var min_dist = trigger_distance
		for part in body_parts:
			if _is_valid_match(part.name, target.name):
				var d = target.global_position.distance_to(part.global_position)
				if d < min_dist:
					min_dist = d
		distances[target.name] = clamp(min_dist, 0.0, trigger_distance)

	var total_score: float = 0.0
	for part_name in distances:
		total_score += (trigger_distance - distances[part_name]) / trigger_distance
	
	match_coefficient = total_score / distances.size()
	#print(match_coefficient)
	
func getScore():
	return match_coefficient

func toggleBoxes():
	for target in target_nodes:
		var box = $rect
		if box.visible == true:
			box.visible = false
		elif box.visible == false:
			box.visible = true
	

func _is_valid_match(part_name: String, target_name: String) -> bool:
	match target_name:
		"Head": return "Head" in part_name
		"L_Hand", "R_Hand": return "Hand" in part_name
		"L_Foot", "R_Foot": return "Foot" in part_name
	return false
	
func checkWinCondition() -> bool:
	return match_coefficient > 0.6
