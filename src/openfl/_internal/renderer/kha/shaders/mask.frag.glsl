#version 450

in vec2 vTexCoord;

out vec4 frag;

uniform sampler2D uImage0;

void main(void) {
	
	vec4 color = texture (uImage0, vTexCoord);
	
	if (color.a == 0.0) {
		
		discard;
		
	} else {
		
		frag = color;
		
	}
	
}
