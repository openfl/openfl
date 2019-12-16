package flash.text;

#if flash
import openfl.display.DisplayObject;
import openfl.display.Graphics;
import openfl.display.Shape;

@:final extern class StaticText extends DisplayObject
{
	public var text(default, never):String;
	private function new();
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
