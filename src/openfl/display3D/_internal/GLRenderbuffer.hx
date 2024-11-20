package openfl.display3D._internal;

#if !flash
#if lime
typedef GLRenderbuffer = lime.graphics.opengl.GLRenderbuffer;
#else
typedef GLRenderbuffer = Dynamic;
#end
#end
