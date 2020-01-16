package openfl._internal.backend.lime_standalone; #if openfl_html5

@:enum abstract RenderContextType(String) from String to String
{
	var CAIRO = "cairo";
	var CANVAS = "canvas";
	var DOM = "dom";
	var FLASH = "flash";
	var OPENGL = "opengl";
	var OPENGLES = "opengles";
	var WEBGL = "webgl";
	var CUSTOM = "custom";
}
#end
