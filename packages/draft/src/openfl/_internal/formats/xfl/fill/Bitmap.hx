package openfl._internal.formats.xfl.fill;

import haxe.xml.Fast;
import openfl.geom.Matrix;

class Bitmap
{
	public var bitmapPath:String;
	public var matrix:Matrix;

	public function new() {}

	public static function parse(xml:Fast):Bitmap
	{
		var bitmap:Bitmap = new Bitmap();
		bitmap.bitmapPath = xml.att.bitmapPath;
		for (element in xml.elements)
		{
			switch (element.name)
			{
				case "matrix":
					bitmap.matrix = openfl._internal.formats.xfl.geom.Matrix.parse(element.elements.next());
			}
		}
		return bitmap;
	}
}
