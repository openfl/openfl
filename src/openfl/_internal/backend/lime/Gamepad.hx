package openfl._internal.backend.lime;

#if lime
typedef Gamepad = lime.ui.Gamepad;
#else
typedef Gamepad = Dynamic;
#end
