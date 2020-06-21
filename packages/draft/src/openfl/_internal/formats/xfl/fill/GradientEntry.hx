package openfl._internal.formats.xfl.fill;

import haxe.xml.Fast;

class GradientEntry
{
	public var color:Int;
	public var alpha:Float;
	public var ratio:Float;

	public function new() {}

	public static function parse(xml:Fast):GradientEntry
	{
		var gradientEntry = new GradientEntry();
		gradientEntry.color = xml.has.color == true ? Std.parseInt("0x" + xml.att.color.substr(1)) : 0x000000;
		gradientEntry.ratio = Std.parseFloat(xml.att.ratio);
		gradientEntry.alpha = xml.has.alpha == true ? Std.parseFloat(xml.att.alpha) : 1.0;
		return gradientEntry;
	}
}
