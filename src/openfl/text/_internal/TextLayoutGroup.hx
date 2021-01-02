package openfl.text._internal;

import openfl.text.TextFormat;

#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
@SuppressWarnings("checkstyle:FieldDocComment")
// TODO: Need to measure all characters (including whitespace) but include a value for non-whitespace characters separately (for sake of alignment and wrapping)
class TextLayoutGroup
{
	public var ascent:Float;
	public var descent:Float;
	public var endIndex:Int;
	public var format:TextFormat;
	public var height:Float;
	public var leading:Int;
	public var lineIndex:Int;
	public var offsetX:Float;
	public var offsetY:Float;
	#if (js && html5)
	public var positions:Array<Float>; // TODO: Make consistent with native?
	#else
	public var positions:Array<GlyphPosition>;
	#end
	public var startIndex:Int;
	public var width:Float;

	public function new(format:TextFormat, startIndex:Int, endIndex:Int)
	{
		this.format = format;
		this.startIndex = startIndex;
		this.endIndex = endIndex;
	}

	public inline function getAdvance(index:Int):Float
	{
		#if (js && html5)
		return positions[index];
		#else
		return (index >= 0 && index < positions.length) ? positions[index].advance.x : 0;
		#end
	}
}
