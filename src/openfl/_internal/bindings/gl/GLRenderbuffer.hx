package openfl._internal.bindings.gl;

#if lime
typedef GLRenderbuffer = lime.graphics.opengl.GLRenderbuffer;
#else
@SuppressWarnings("checkstyle:Dynamic")
typedef GLRenderbuffer = Dynamic;
#end
