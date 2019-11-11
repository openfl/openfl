package openfl._internal.backend.lime;

#if lime
typedef GamepadAxis = lime.ui.GamepadAxis;
#else
typedef GamepadAxis = Dynamic;
#end
