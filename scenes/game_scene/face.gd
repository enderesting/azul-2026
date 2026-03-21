extends Sprite2D
@onready var l_eye: ColorRect = $"../L_Eye"
@onready var r_eye: ColorRect = $"../R_Eye"
@onready var scaler: float = 0.2

# range: -0.25, 0.25
func _process(delta: float) -> void:
	l_eye.get_material().set_shader_parameter("PUPIL_OFFSET",get_eye_v(l_eye.global_position))
	r_eye.get_material().set_shader_parameter("PUPIL_OFFSET",get_eye_v(r_eye.global_position))

func get_eye_v(eye_pos: Vector2) -> Vector2:
	var eye_v = (l_eye.global_position - get_global_mouse_position()).normalized()
	return -Vector2( eye_v.x*scaler, eye_v.y*scaler)
