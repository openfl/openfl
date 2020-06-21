package openfl._internal.formats.xfl.fill;

import haxe.xml.Fast;

class FillStyle
{
	public var data:Dynamic;
	public var index:Int;

	public function new() {}

	public static function parse(xml:Fast):FillStyle
	{
		var fillStyle = new FillStyle();
		fillStyle.index = Std.parseInt(xml.att.index);
		for (element in xml.elements)
		{
			switch (element.name)
			{
				case "SolidColor":
					fillStyle.data = SolidColor.parse(element);
				case "LinearGradient":
					fillStyle.data = LinearGradient.parse(element);
				case "RadialGradient":
					fillStyle.data = RadialGradient.parse(element);
				case "BitmapFill":
					fillStyle.data = Bitmap.parse(element);
			}
		}
		return fillStyle;
	}
}
