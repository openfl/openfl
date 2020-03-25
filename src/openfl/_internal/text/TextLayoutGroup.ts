namespace openfl._internal.text;

import openfl.text.TextFormat;

#if!openfl_debug
@: fileXml('tags="haxe,release"')
@: noDebug
#end
@SuppressWarnings("checkstyle:FieldDocComment")
// TODO: Need to measure all characters (including whitespace) but include a value for non-whitespace characters separately (for sake of alignment and wrapping)
class TextLayoutGroup
{
	public ascent: number;
	public descent: number;
	public endIndex: number;
	public format: TextFormat;
	public height: number;
	public leading: number;
	public lineIndex: number;
	public offsetX: number;
	public offsetY: number;
	#if(!lime || openfl_html5)
	public positions: Array<Float>; // TODO: Make consistent with native?
	#else
	public positions: Array<GlyphPosition>;
	#end
	public startIndex: number;
	public width: number;

public new (format: TextFormat, startIndex : number, endIndex : number)
{
	this.format = format;
	this.startIndex = startIndex;
	this.endIndex = endIndex;
}

	public inline getAdvance(index : number) : number
{
		#if(!lime || openfl_html5)
	return positions[index];
		#else
	return (index >= 0 && index < positions.length) ? positions[index].advance.x : 0;
		#end
}
}
