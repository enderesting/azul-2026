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
	# 1. Reset distances to the maximum (no match state)
	for key in distances.keys():
		distances[key] = trigger_distance
	
	# 2. Update distances based on current positions
	for target in target_nodes:
		if not target is Node2D:
			continue
		
		for part in body_parts:
			var temp_name = part.name
			if part.name == "R_Hand":
				temp_name = "L_Hand"
			if part.name == "R_Foot":
				temp_name = "L_Foot"
			
			if temp_name == target.name and distances.has(target.name):
				var d = target.global_position.distance_to(part.global_position)

				distances[target.name] = clamp(d, 0.0, trigger_distance)

				

	var total_score: float = 0.0
	for part_name in distances:
		var score = (trigger_distance - distances[part_name]) / trigger_distance
		total_score += score
	
	match_coefficient = total_score / distances.size()
	print (match_coefficient)
