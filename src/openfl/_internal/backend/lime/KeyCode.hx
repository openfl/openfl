package openfl._internal.backend.lime;

#if lime
typedef KeyCode = lime.ui.KeyCode;
#else
typedef KeyCode = Dynamic;
#end
