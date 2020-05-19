package openfl._internal.backend.gl;

#if lime
typedef GLUniformLocation = lime.graphics.opengl.GLUniformLocation;
#else
@SuppressWarnings("checkstyle:Dynamic")
typedef GLUniformLocation = Dynamic;
#end
