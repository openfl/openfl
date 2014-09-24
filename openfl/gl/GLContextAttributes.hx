package openfl.gl;


#if (!openfl_next && !flash && !js && !display)
typedef GLContextAttributes = openfl._v2.gl.GLContextAttributes;
#else
typedef GLContextAttributes = lime.graphics.opengl.GLContextAttributes;
#end