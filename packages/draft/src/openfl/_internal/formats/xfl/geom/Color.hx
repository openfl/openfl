package openfl._internal.formats.xfl.geom;

import haxe.xml.Fast;
import openfl.geom.ColorTransform;

class Color extends ColorTransform
{
	public function new(redMultiplier:Float = 1, greenMultiplier:Float = 1, blueMultiplier:Float = 1, alphaMultiplier:Float = 1, redOffset:Float = 0,
			greenOffset:Float = 0, blueOffset:Float = 0, alphaOffset:Float = 0)
	{
		super(redMultiplier, greenMultiplier, blueMultiplier, alphaMultiplier, redOffset, greenOffset, blueOffset, alphaOffset);
	}

	public static function parse(xml:Fast):Color
	{
		var color = new Color();
		if (xml.has.alphaMultiplier) color.alphaMultiplier = Std.parseFloat(xml.att.alphaMultiplier);
		if (xml.has.alphaOffset) color.alphaOffset = Std.parseFloat(xml.att.alphaOffset);
		if (xml.has.blueMultiplier) color.blueMultiplier = Std.parseFloat(xml.att.blueMultiplier);
		if (xml.has.blueOffset) color.blueOffset = Std.parseFloat(xml.att.blueOffset);
		if (xml.has.greenMultiplier) color.greenMultiplier = Std.parseFloat(xml.att.greenMultiplier);
		if (xml.has.greenOffset) color.greenOffset = Std.parseFloat(xml.att.greenOffset);
		if (xml.has.redMultiplier) color.redMultiplier = Std.parseFloat(xml.att.redMultiplier);
		if (xml.has.redOffset) color.redOffset = Std.parseFloat(xml.att.redOffset);
		if (xml.has.tintColor)
		{
			color.redMultiplier = 0;
			color.greenMultiplier = 0;
			color.blueMultiplier = 0;
			color.redOffset = Std.parseInt("0x" + xml.att.tintColor.substr(1, 2));
			color.greenOffset = Std.parseInt("0x" + xml.att.tintColor.substr(3, 2));
			color.blueOffset = Std.parseInt("0x" + xml.att.tintColor.substr(5, 2));
		}
		if (xml.has.tintMultiplier)
		{
			var multiplier = 1 - Std.parseFloat(xml.att.tintMultiplier);
			color.redMultiplier = multiplier;
			color.greenMultiplier = multiplier;
			color.blueMultiplier = multiplier;
		}
		return color;
	}
}
