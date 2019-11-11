package openfl._internal.backend.lime;

#if lime
typedef Image = lime.graphics.Image;
#else
typedef Image = Dynamic;
#end
