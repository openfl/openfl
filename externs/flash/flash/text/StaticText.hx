package flash.text;

#if flash
import openfl.display.DisplayObject;

@:final extern class StaticText extends DisplayObject
{
	public var text(default, never):String;
	private function new();
}
#else
typedef StaticText = openfl.text.StaticText;
#end
