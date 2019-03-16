package openfl._internal.formats.xfl.fill;

import openfl.geom.Matrix;
import haxe.xml.Fast;

class RadialGradient
{
	public var entries:Array<GradientEntry>;
	public var matrix:Matrix;
	public var spreadMethod:String;

	public function new()
	{
		entries = new Array<GradientEntry>();
	}

	public static function parse(xml:Fast):RadialGradient
	{
		var radialGradient = new RadialGradient();
		radialGradient.spreadMethod = xml.has.spreadMethod == true ? xml.att.spreadMethod : "pad";
		for (element in xml.elements)
		{
			switch (element.name)
			{
				case "matrix":
					radialGradient.matrix = openfl._internal.formats.xfl.geom.Matrix.parse(element.elements.next());
				case "GradientEntry":
					radialGradient.entries.push(GradientEntry.parse(element));
			}
		}
		return radialGradient;
	}
}
