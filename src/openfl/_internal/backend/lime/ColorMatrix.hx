package openfl._internal.backend.lime;

#if lime
typedef ColorMatrix = lime.math.ColorMatrix;
#else
typedef ColorMatrix = Dynamic;
#end
