package openfl._internal.formats.xfl.stroke;

import openfl._internal.formats.xfl.fill.SolidColor;
import haxe.xml.Fast;

class SolidStroke
{
	public var fill:Dynamic;
	public var scaleMode:String;
	public var weight:Float;

	public function new()
	{
		weight = 1;
	}

	public static function parse(xml:Fast):SolidStroke
	{
		var solidStroke = new SolidStroke();
		if (xml.has.scaleMode) solidStroke.scaleMode = xml.att.scaleMode;
		if (xml.has.weight) solidStroke.weight = Std.parseFloat(xml.att.weight);
		for (element in xml.elements)
		{
			switch (element.name)
			{
				case "fill":
					var childElement = element.elements.next();
					switch (childElement.name)
					{
						case "SolidColor":
							solidStroke.fill = SolidColor.parse(childElement);
					}
			}
		}
		return solidStroke;
	}
}
