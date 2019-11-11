package openfl._internal.backend.lime;

#if lime
typedef Clipboard = lime.system.Clipboard;
#else
typedef Clipboard = Dynamic;
#end
