package openfl._internal.backend.lime;

#if lime
typedef ImageChannel = lime.graphics.ImageChannel;
#else
typedef ImageChannel = Dynamic;
#end
