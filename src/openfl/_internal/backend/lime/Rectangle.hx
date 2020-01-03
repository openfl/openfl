package openfl._internal.backend.lime;

#if lime
typedef Rectangle = lime.math.Rectangle;
#else
typedef Rectangle = Dynamic;
#end
