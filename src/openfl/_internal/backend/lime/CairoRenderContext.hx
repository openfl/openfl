package openfl._internal.backend.lime;

#if lime
typedef CairoRenderContext = lime.graphics.CairoRenderContext;
#else
typedef CairoRenderContext = Dynamic;
#end
