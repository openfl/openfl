#version 450

in float vAlpha;
in vec4 vColorMultipliers0;
in vec4 vColorMultipliers1;
in vec4 vColorMultipliers2;
in vec4 vColorMultipliers3;
in vec4 vColorOffsets;
in vec2 vTexCoord;
out vec4 fragColor;

uniform bool uColorTransform;
uniform sampler2D uImage0;

void main(void) {
	
	vec4 color = texture (uImage0, vTexCoord);
	
	if (color.a == 0.0) {
		
		fragColor = vec4 (0.0, 0.0, 0.0, 0.0);
		
	} else if (uColorTransform) {
		
		color = vec4 (color.rgb / color.a, color.a);
		
		mat4 colorMultiplier;
		colorMultiplier[0] = vColorMultipliers0;
		colorMultiplier[1] = vColorMultipliers1;
		colorMultiplier[2] = vColorMultipliers2;
		colorMultiplier[3] = vColorMultipliers3;
		
		color = vColorOffsets + (color * colorMultiplier);
		
		if (color.a > 0.0) {
			
			fragColor = vec4 (color.rgb * color.a * vAlpha, color.a * vAlpha);
			
		} else {
			
			fragColor = vec4 (0.0, 0.0, 0.0, 0.0);
			
		}
		
	} else {
		
		fragColor = color * vAlpha;
		
	}
	
}