package openfl._internal.bindings.gl;

#if lime
typedef GLFramebuffer = lime.graphics.opengl.GLFramebuffer;
#else
@SuppressWarnings("checkstyle:Dynamic")
typedef GLFramebuffer = Dynamic;
#end
