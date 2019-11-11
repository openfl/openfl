package openfl._internal.backend.cairo;

#if lime
typedef CairoOperator = lime.graphics.cairo.CairoOperator;
#else
typedef CairoOperator = Dynamic;
#end
