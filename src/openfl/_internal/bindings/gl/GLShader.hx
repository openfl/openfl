package openfl._internal.bindings.gl;

#if lime
typedef GLShader = lime.graphics.opengl.GLShader;
#else
@SuppressWarnings("checkstyle:Dynamic")
typedef GLShader = Dynamic;
#end
