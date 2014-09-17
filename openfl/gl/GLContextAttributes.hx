package openfl.gl;


#if (!next && !flash && !js && !display)
typedef GL = openfl._v2.gl.GLContextAttributes;
#else
typedef GLContextAttributes = lime.graphics.opengl.GLContextAttributes;
#end