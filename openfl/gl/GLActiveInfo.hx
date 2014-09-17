package openfl.gl;


#if (!next && !flash && !js && !display)
typedef GL = openfl._v2.gl.GLActiveInfo;
#else
typedef GLActiveInfo = lime.graphics.opengl.GLActiveInfo;
#end