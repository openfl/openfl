package openfl.gl;


#if (!next && !flash && !js)
typedef GL = openfl._v2.gl.GLContextAttributes;
#else
typedef GLContextAttributes = lime.graphics.opengl.GLContextAttributes;
#end