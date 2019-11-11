package openfl._internal.backend.lime;

#if lime
typedef WindowAttributes = lime.ui.WindowAttributes;
#else
typedef WindowAttributes = Dynamic;
#end
