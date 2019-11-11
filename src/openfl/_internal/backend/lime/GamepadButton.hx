package openfl._internal.backend.lime;

#if lime
typedef GamepadButton = lime.ui.GamepadButton;
#else
typedef GamepadButton = Dynamic;
#end
