package openfl._internal.backend.cairo;

#if lime
typedef CairoImageSurface = lime.graphics.cairo.CairoImageSurface;
#else
typedef CairoImageSurface = Dynamic;
#end
