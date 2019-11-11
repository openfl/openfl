package openfl._internal.backend.cairo;

#if lime
typedef CairoSurface = lime.graphics.cairo.CairoSurface;
#else
typedef CairoSurface = Dynamic;
#end
