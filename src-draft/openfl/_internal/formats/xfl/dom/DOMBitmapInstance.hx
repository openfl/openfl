package openfl._internal.formats.xfl.dom;

import openfl.geom.Matrix;
import openfl.geom.Point;
import haxe.xml.Fast;

class DOMBitmapInstance
{
	public var libraryItemName:String;
	public var matrix:Matrix;
	public var transformationPoint:Point;

	public function new() {}

	public static function parse(xml:Fast):DOMBitmapInstance
	{
		var bitmapInstance:DOMBitmapInstance = new DOMBitmapInstance();
		bitmapInstance.libraryItemName = xml.att.libraryItemName;
		for (element in xml.elements)
		{
			switch (element.name)
			{
				case "transformationPoint":
					bitmapInstance.transformationPoint = openfl._internal.formats.xfl.geom.Point.parse(element.elements.next());
				case "matrix":
					bitmapInstance.matrix = openfl._internal.formats.xfl.geom.Matrix.parse(element.elements.next());
			}
		}
		return bitmapInstance;
	}
}
