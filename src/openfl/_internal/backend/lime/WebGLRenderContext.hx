package openfl._internal.backend.lime;

#if lime
typedef WebGLRenderContext = lime.graphics.WebGLRenderContext;
#else
typedef WebGLRenderContext = Dynamic;
#end
