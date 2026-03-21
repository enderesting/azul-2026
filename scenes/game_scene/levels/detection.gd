extends Node2D

@export var trigger_distance: float = 200.0

var body_parts: Array[Node] = []
var target_nodes: Array[Node] = []

# Dictionary to store current distance for each part
var distances: Dictionary = {
	"Head": 200.0,
	"L_Hand": 200.0,
	"R_Hand": 200.0,
	"L_Foot": 200.0,
	"R_Foot": 200.0
}

var match_coefficient: float = 0.0

func _ready() -> void:
	body_parts = get_tree().get_nodes_in_group("player_points")
	target_nodes = get_children()

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


func _is_valid_match(part_name: String, target_name: String) -> bool:
	match target_name:
		"Head": return part_name == "Head"
		"L_Hand", "R_Hand": return "Hand" in part_name
		"L_Foot", "R_Foot": return "Foot" in part_name
	return false
	
func checkWinCondition() -> bool:
	return match_coefficient > 0.6
