package openfl._internal.backend.lime;

#if lime
typedef FileDialog = lime.ui.FileDialog;
#else
typedef FileDialog = Dynamic;
#end
