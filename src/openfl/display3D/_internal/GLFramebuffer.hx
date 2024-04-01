package openfl.display3D._internal;

#if !flash
#if lime
typedef GLFramebuffer = lime.graphics.opengl.GLFramebuffer;
#else
typedef GLFramebuffer = Dynamic;
#end
#end
