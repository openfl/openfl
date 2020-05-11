package openfl.text;

import openfl.display._DisplayObject;
import openfl.display.Graphics;

#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
@:access(openfl.display.Graphics)
@:noCompletion
class _StaticText extends _DisplayObject
{
	public var text:String;

	public function new(staticText:StaticText)
	{
		super(staticText);

		__graphics = new Graphics(parent);
	}
}
