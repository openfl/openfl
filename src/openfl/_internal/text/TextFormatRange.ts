namespace openfl._internal.text;

import openfl.text.TextFormat;

#if!openfl_debug
@: fileXml('tags="haxe,release"')
@: noDebug
#end
class TextFormatRange
{
	public end: number;
	public format: TextFormat;
	public start: number;

	public constructor(format: TextFormat, start: number, end: number)
	{
		this.format = format;
		this.start = start;
		this.end = end;
	}
}
