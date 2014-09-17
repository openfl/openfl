package openfl.gl;


#if (!next && !flash && !js && !display)
typedef GL = openfl._v2.gl.GLObject;
#else
typedef GLObject = lime.graphics.opengl.GLObject;
#end