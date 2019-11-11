package openfl._internal.backend.cairo;

#if lime
typedef CairoFilter = lime.graphics.cairo.CairoFilter;
#else
typedef CairoFilter = Dynamic;
#end
