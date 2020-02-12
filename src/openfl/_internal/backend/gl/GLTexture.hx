package openfl._internal.backend.gl;

#if lime
typedef GLTexture = lime.graphics.opengl.GLTexture;
#else
@SuppressWarnings("checkstyle:Dynamic")
typedef GLTexture = Dynamic;
#end
