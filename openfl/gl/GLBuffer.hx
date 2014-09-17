package openfl.gl;


#if (!next && !flash && !js && !display)
typedef GLBuffer = openfl._v2.gl.GLBuffer;
#else
typedef GLBuffer = lime.graphics.opengl.GLBuffer;
#end