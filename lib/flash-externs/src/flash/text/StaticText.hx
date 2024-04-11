package flash.text;

#if flash
import openfl.display.DisplayObject;
import openfl.display.Graphics;
import openfl.display.Shape;

@:final extern class StaticText extends DisplayObject
{
	#if (haxe_ver < 4.3)
	public var text(default, never):String;
	#else
	@:flash.property var text(get, never):String;
	#end

	private function new();

	#if (haxe_ver >= 4.3)
	private function get_text():String;
	#end
}

@:noCompletion class StaticText2 extends Shape
{
	public var text:String;
	public var __graphics:Graphics;

	public function new()
	{
		super();
		__graphics = graphics;
	}
}
#else
typedef StaticText = openfl.text.StaticText;
#end
