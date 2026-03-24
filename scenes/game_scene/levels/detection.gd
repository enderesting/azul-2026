extends Node2D

@export var trigger_distance: float = 200.0
@export var show_debug_visuals: bool = true
@export var allowance: int = 80
@export var thres: float = 0.6
@export var OffsetHead: float = 50.0

var body_parts: Array[Node] = []
var target_nodes: Array[Node]

var distances: Dictionary = {}

var match_coefficient: float = 0.0

func _ready() -> void:
	body_parts = get_tree().get_nodes_in_group("player_points")
	target_nodes = []
	distances.clear()
	
	for child in get_children():
		if child is Node2D:
			target_nodes.append(child)
			distances[child.name] = trigger_distance
	
	body_parts = body_parts.filter(func(part): 
		return distances.has(part.name)
	)

	body_parts.sort_custom(func(a, b): return a.name < b.name)
	target_nodes.sort_custom(func(a, b): return a.name < b.name)
		_setup_target_visuals(target_nodes)
		_setup_target_visuals(body_parts)

func _setup_target_visuals(nodes: Array[Node]) -> void:
	for target in nodes:
		if not target is Node2D: continue
		
		var headOffset = 0
		var boxSize = allowance
		if "Head" in target.name and target.is_in_group("player_points"):
			headOffset -= OffsetHead
			boxSize = allowance * 2
			
		var rect = ReferenceRect.new()
		rect.name = "box"
		rect.size = Vector2(boxSize, boxSize) 
		rect.position = (-rect.size / 2).round() 
		rect.position.y += headOffset
		rect.border_color = Color.GREEN
		rect.border_width = 3.0 
		rect.editor_only = false 
		rect.visible = false
		rect.z_index = 12
		target.add_child(rect)
		target.move_child(rect, 0)
		
		var label = Label.new()
		label.name = "coef"
		label.text = ""
		label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		label.position = Vector2(-50, (-rect.size.y / 2 - 25) + headOffset)
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
				var pos = part.global_position
				if part.name == "Head":
					pos.y -= OffsetHead
				var d = target.global_position.distance_to(part.global_position)
				if d < min_dist:
					min_dist = d
		distances[target.name] = clamp(min_dist, 0.0, trigger_distance)

	var total_score: float = 0.0
	for part_name in distances:
		total_score += (trigger_distance - distances[part_name]) / trigger_distance
	
	match_coefficient = total_score / distances.size()
	
func getScore():
	return match_coefficient

func checkBoxes():
	for i in range(target_nodes.size()):
		if i >= body_parts.size(): break
		
		var target = target_nodes[i]
		var part = body_parts[i]
		
		var dist_value = distances.get(target.name, trigger_distance)
		
		var target_box = target.get_node_or_null("box")
		var body_box = part.get_node_or_null("box")
		var body_label = part.get_node_or_null("coef")
		
		if target_box and body_box:
			if dist_value < allowance:
				print("DEBUG: correct box")
				print(body_parts[i])
				print(target_nodes[i])
				target_box.visible = true
				target_box.border_color = Color.GREEN
				
				body_box.visible = false
				if body_label: body_label.visible = false
			else:
				print("DEBUG: Wrong box")
				print(body_parts[i])
				print(target_nodes[i])
				target_box.visible = true
				target_box.border_color = Color.ORANGE
				
				body_box.visible = true
				body_box.border_color = Color.RED
				if body_label:
					body_label.visible = true
					var part_score = (trigger_distance - dist_value) / trigger_distance
					body_label.text = "%.1f" % part_score

func _is_valid_match(part_name: String, target_name: String) -> bool:
	match target_name:
		"Head": return "Head" in part_name
		"L_Hand", "R_Hand": return "Hand" in part_name
		"L_Foot", "R_Foot": return "Foot" in part_name
		"L_Elbow", "R_Elbow": return "Elbow" in part_name
		"L_Knee", "R_Knee": return "Knee" in part_name
	return false

func checkWinCondition() -> bool:
	return match_coefficient > thres
