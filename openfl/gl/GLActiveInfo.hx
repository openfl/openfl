package openfl.gl;


#if (!openfl_next && !flash && !js && !display)
typedef GLActiveInfo = openfl._v2.gl.GLActiveInfo;
#else
typedef GLActiveInfo = lime.graphics.opengl.GLActiveInfo;
#end