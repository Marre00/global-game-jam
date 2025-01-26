shader_type canvas_item;

uniform float speed = 0.1;

void fragment() {
	vec2 newuv = UV;
	newuv.x += TIME * speed;
}
