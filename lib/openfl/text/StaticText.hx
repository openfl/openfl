package openfl.text;

#if (display || !flash)
import openfl.display.DisplayObject;

#if !openfl_global
@:jsRequire("openfl/text/StaticText", "default")
#end
@:final extern class StaticText extends DisplayObject
{
	public var text(default, null):String;
	private function new();
}
#else
typedef StaticText = flash.text.StaticText;
#end
