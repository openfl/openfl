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

	private var staticText:StaticText;

	public function new(staticText:StaticText)
	{
		this.staticText = staticText;

		super(staticText);

		__graphics = new Graphics(staticText);
	}
}
