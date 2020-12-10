package openfl.text._internal;

import openfl.text.TextFormat;

#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
class TextFormatRange
{
	public var end:Int;
	public var format:TextFormat;
	public var start:Int;

	public function new(format:TextFormat, start:Int, end:Int)
	{
		this.format = format;
		this.start = start;
		this.end = end;
	}
}
