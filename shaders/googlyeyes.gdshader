shader_type canvas_item;
 
uniform float EYE_RADIUS: hint_range(0.3, 0.5) = 0.4;
uniform float PUPIL_RADIUS: hint_range(0.05, 0.3) = 0.2;
 
uniform vec2 PUPIL_OFFSET = vec2(0.1, 0.1);
uniform vec2 EYE_OFFSET = vec2(0.0, 0.0);
 
uniform vec4 black: source_color = vec4(0.09, 0.12, 0.16, 1);
uniform vec4 white: source_color = vec4(0.87, 0.83, 0.78, 1);
 
uniform float top: hint_range(0, 0.5) = 0;
uniform float bottom: hint_range(0.5, 1) = 1;
 
const vec2 CENTER = vec2(0.5, 0.5);
const vec4 TRANSPARENT = vec4(0,0,0,0);
 
varying flat vec4 modulate;
void vertex() {
	modulate = COLOR;
}
 
void fragment() {
	if (UV.y > top && UV.y < bottom){
 
		 if (length(UV-CENTER-EYE_OFFSET) < EYE_RADIUS) {
			COLOR = white*modulate;
 
			if (length(UV-CENTER-PUPIL_OFFSET) < PUPIL_RADIUS){
				COLOR = black*modulate;
			}
		} else {
			COLOR = TRANSPARENT;
		}
	}
	else {
		COLOR = TRANSPARENT;
	}
}