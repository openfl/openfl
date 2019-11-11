package openfl._internal.backend.lime;

#if lime
typedef Window = lime.ui.Window;
#else
typedef Window = Dynamic;
#end
