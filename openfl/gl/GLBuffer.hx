package openfl.gl;


#if (!next && !flash && !js && !display)
typedef GL = openfl._v2.gl.GLBuffer;
#else
typedef GLBuffer = lime.graphics.opengl.GLBuffer;
#end