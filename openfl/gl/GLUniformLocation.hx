package openfl.gl;


#if (!next && !flash && !js && !display)
typedef GL = openfl._v2.gl.GLUniformLocation;
#else
typedef GLUniformLocation = lime.graphics.opengl.GLUniformLocation;
#end