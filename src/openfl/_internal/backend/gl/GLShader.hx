package openfl._internal.backend.gl;

#if lime
typedef GLShader = lime.graphics.opengl.GLShader;
#else
@SuppressWarnings("checkstyle:Dynamic")
typedef GLShader = Dynamic;
#end
