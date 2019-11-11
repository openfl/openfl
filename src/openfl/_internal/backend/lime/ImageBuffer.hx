package openfl._internal.backend.lime;

#if lime
typedef ImageBuffer = lime.graphics.ImageBuffer;
#else
typedef ImageBuffer = Dynamic;
#end
