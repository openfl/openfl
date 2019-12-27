package openfl._internal.backend.lime_standalone;

#if openfl_html5
@:enum abstract AssetType(String) to String
{
	var BINARY = "BINARY";
	var FONT = "FONT";
	var IMAGE = "IMAGE";
	var MANIFEST = "MANIFEST";
	var MUSIC = "MUSIC";
	var SOUND = "SOUND";
	var TEMPLATE = "TEMPLATE";
	var TEXT = "TEXT";
}
#end
