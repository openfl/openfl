package openfl._internal.backend.lime;

#if lime
typedef Canvas2DRenderContext = lime.graphics.Canvas2DRenderContext;
#else
typedef Canvas2DRenderContext = Dynamic;
#end
