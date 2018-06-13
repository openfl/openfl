#version 450

in vec4 aPosition;
in vec2 aTexCoord;
out vec2 vTexCoord;

uniform mat4 uMatrix;

void main(void) {
	
	vTexCoord = aTexCoord;
	
	gl_Position = uMatrix * aPosition;
	
}
