package openfl.gl;


#if (!openfl_next && !flash && !js && !display)
typedef GLObject = openfl._v2.gl.GLObject;
#else
typedef GLObject = lime.graphics.opengl.GLObject;
#end