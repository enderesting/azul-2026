extends Node2D


@export var body_part: Node2D 
@export var target_point: Node2D 
@export var trigger_distance: float = 200.0
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if body_part and target_point:
		var distance = global_position.distance_to(body_part.global_position)
		
		if distance < trigger_distance:
			print("Player is close! Distance: ", distance)
