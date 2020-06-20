package openfl._internal.backend.gl;

#if lime
typedef GLProgram = lime.graphics.opengl.GLProgram;
#else
@SuppressWarnings("checkstyle:Dynamic")
typedef GLProgram = Dynamic;
#end
