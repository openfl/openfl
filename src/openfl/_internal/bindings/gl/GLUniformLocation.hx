package openfl._internal.bindings.gl;

#if lime
typedef GLUniformLocation = lime.graphics.opengl.GLUniformLocation;
#else
@SuppressWarnings("checkstyle:Dynamic")
typedef GLUniformLocation = Dynamic;
#end
