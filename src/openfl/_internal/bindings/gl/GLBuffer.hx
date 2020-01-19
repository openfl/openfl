package openfl._internal.bindings.gl;

#if lime
typedef GLBuffer = lime.graphics.opengl.GLBuffer;
#else
@SuppressWarnings("checkstyle:Dynamic")
typedef GLBuffer = Dynamic;
#end
