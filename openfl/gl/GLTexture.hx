package openfl.gl;


#if (!next && !flash && !js && !display)
typedef GLTexture = openfl._v2.gl.GLTexture;
#else
typedef GLTexture = lime.graphics.opengl.GLTexture;
#end