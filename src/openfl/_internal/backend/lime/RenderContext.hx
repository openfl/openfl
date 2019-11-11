package openfl._internal.backend.lime;

#if lime
typedef RenderContext = lime.graphics.RenderContext;
#else
typedef RenderContext = Dynamic;
#end
