extends Node2D

@export var trigger_distance: float = 200.0


var body_parts: Array[Node] = []

var target_nodes: Array[Node] = []
var distances: Array[int] = [100,100,100,100,100]

func _ready() -> void:
	body_parts = get_tree().get_nodes_in_group("player_points")
	
	target_nodes = get_children()

func _process(_delta: float) -> void:
	for target in target_nodes:
		if not target is Node2D:
			continue
		for part in body_parts:
			if part.name == target.name:
				var distance = target.global_position.distance_to(part.global_position)
			
				
				if distance < trigger_distance:
					_handle_proximity(part, target, distance)

func _handle_proximity(part: Node2D, target: Node2D, dist: float):
	match target.name:
		"Head":
			pass
			#print("Proximity: ", target.name, " is ", dist, " units away.") 
		"LHand":
			pass
			#print("Proximity: ", target.name, " is ", dist, " units away.")
		"RHand":
			print("Proximity: ", target.name, " is ", dist, " units away.")
		"LFoot":
			print("Proximity: ", target.name, " is ", dist, " units away.")
		"RFoot":
			print("Proximity: ", target.name, " is ", dist, " units away.")
