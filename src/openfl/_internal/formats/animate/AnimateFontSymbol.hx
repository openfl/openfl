package openfl._internal.formats.animate;

import openfl._internal.formats.swf.ShapeCommand;

#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
class AnimateFontSymbol extends AnimateSymbol
{
	public var advances:Array<Int>;
	public var ascent:Int;
	public var bold:Bool;
	public var codes:Array<Int>;
	public var descent:Int;
	public var glyphs:Array<Array<ShapeCommand>>;
	public var italic:Bool;
	public var leading:Int;
	public var name:String;

	public function new()
	{
		super();
	}
}
