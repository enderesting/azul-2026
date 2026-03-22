extends Sprite2D
@onready var l_eye: ColorRect = $"../L_Eye"
@onready var r_eye: ColorRect = $"../R_Eye"
@onready var scaler: float = 0.2
@onready var anim_player: AnimationPlayer = $"../AnimationPlayer"


func _ready() -> void:
	Global.face_worried.connect(_on_head_worried)
	Global.face_relaxed.connect(_on_head_relaxed)
# range: -0.25, 0.25
func _process(delta: float) -> void:
	l_eye.get_material().set_shader_parameter("PUPIL_OFFSET",get_eye_v(l_eye.global_position))
	r_eye.get_material().set_shader_parameter("PUPIL_OFFSET",get_eye_v(r_eye.global_position))

func get_eye_v(eye_pos: Vector2) -> Vector2:
	var eye_v = (l_eye.global_position - get_global_mouse_position()).normalized()
	return -Vector2( eye_v.x*scaler, eye_v.y*scaler)	
	
func _on_head_normal() -> void:
	pass # Replace with function body.


func _on_head_worried() -> void:
	# print("GET WORRIED")
	#l_eye.get_material().set_shader_parameter("top_alpha",0.5)
	#r_eye.get_material().set_shader_parameter("top_alpha",-0.5)
	#var set_sad = func(v): 
		#l_eye.get_material().set_shader_parameter("top",v)
		#r_eye.get_material().set_shader_parameter("top",v)
	#create_tween().tween_method(set_sad,0,1,1)
	#pass # Replace with function body.
	anim_player.play("face_worried")

func _on_head_relaxed() -> void:
	# print("ok relax now")
	anim_player.play_backwards("face_worried")
