package openfl._internal.backend.lime;

#if lime
typedef Touch = lime.ui.Touch;
#else
typedef Touch = Dynamic;
#end
