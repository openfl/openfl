package openfl._internal.formats.xfl.dom;

import openfl._internal.formats.xfl.geom.Color;
import openfl.geom.Matrix;
import openfl.geom.Point;
import haxe.xml.Fast;

class DOMSymbolInstance
{
	public var cacheAsBitmap:Bool;
	public var color:Color;
	public var exportAsBitmap:Bool;
	public var libraryItemName:String;
	public var loop:String;
	public var matrix:Matrix;
	public var name:String;
	public var symbolType:String;
	public var transformationPoint:Point;

	public function new() {}

	public function clone():DOMSymbolInstance
	{
		var duplicate:DOMSymbolInstance = new DOMSymbolInstance();
		if (color != null) duplicate.color = new Color(color.redMultiplier, color.greenMultiplier, color.blueMultiplier, color.alphaMultiplier,
			color.redOffset, color.greenOffset, color.blueOffset, color.alphaOffset);
		duplicate.libraryItemName = libraryItemName;
		duplicate.loop = loop;
		if (matrix != null) duplicate.matrix = new Matrix(matrix.a, matrix.b, matrix.c, matrix.d, matrix.tx, matrix.ty);
		duplicate.name = name;
		duplicate.symbolType = symbolType;
		duplicate.transformationPoint = transformationPoint;
		return duplicate;
	}

	public static function parse(xml:Fast):DOMSymbolInstance
	{
		var symbolInstance = new DOMSymbolInstance();
		symbolInstance.libraryItemName = xml.att.libraryItemName;
		if (xml.has.name) symbolInstance.name = xml.att.name;
		if (xml.has.symbolType) symbolInstance.symbolType = xml.att.symbolType;
		if (xml.has.loop) symbolInstance.loop = xml.att.loop;
		if (xml.has.cacheAsBitmap) symbolInstance.cacheAsBitmap = (xml.att.cacheAsBitmap == "true");
		if (xml.has.exportAsBitmap) symbolInstance.exportAsBitmap = (xml.att.exportAsBitmap == "true");
		for (element in xml.elements)
		{
			switch (element.name)
			{
				case "transformationPoint":
					symbolInstance.transformationPoint = openfl._internal.formats.xfl.geom.Point.parse(element.elements.next());
				case "matrix":
					symbolInstance.matrix = openfl._internal.formats.xfl.geom.Matrix.parse(element.elements.next());
				case "color":
					symbolInstance.color = Color.parse(element.elements.next());
			}
		}
		return symbolInstance;
	}
}
