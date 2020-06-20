package openfl._internal.formats.xfl.stroke;

import haxe.xml.Fast;

class StrokeStyle
{
	public var data:Dynamic;
	public var index:Int;

	public function new() {}

	public static function parse(xml:Fast):StrokeStyle
	{
		var strokeStyle = new StrokeStyle();
		strokeStyle.index = Std.parseInt(xml.att.index);
		for (element in xml.elements)
		{
			switch (element.name)
			{
				case "SolidStroke":
					strokeStyle.data = SolidStroke.parse(element);
			}
		}
		return strokeStyle;
	}
}
