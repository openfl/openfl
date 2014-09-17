package openfl.gl;


#if (!next && !flash && !js)
typedef GL = openfl._v2.gl.GLActiveInfo;
#else
typedef GLActiveInfo = lime.graphics.opengl.GLActiveInfo;
#end