package openfl._internal.formats.xfl.dom;

import openfl._internal.formats.xfl.fill.FillStyle;
import openfl.geom.Matrix;
import openfl.geom.Point;
import openfl._internal.formats.xfl.stroke.StrokeStyle;
import haxe.xml.Fast;

class DOMRectangle extends DOMShapeBase
{
	public var matrix:Matrix;
	public var transformationPoint:Point;
	public var x:Float;
	public var y:Float;
	public var width:Float;
	public var height:Float;

	public function new()
	{
		super();
	}

	public static function parse(xml:Fast):DOMRectangle
	{
		var shape = new DOMRectangle();
		shape.x = Std.parseFloat(xml.att.x);
		shape.y = Std.parseFloat(xml.att.y);
		shape.width = Std.parseFloat(xml.att.objectWidth);
		shape.height = Std.parseFloat(xml.att.objectHeight);
		for (element in xml.elements)
		{
			switch (element.name)
			{
				case "transformationPoint":
					shape.transformationPoint = openfl._internal.formats.xfl.geom.Point.parse(element.elements.next());
				case "matrix":
					shape.matrix = openfl._internal.formats.xfl.geom.Matrix.parse(element.elements.next());
				case "fills":
					for (childElement in element.elements)
					{
						shape.fills.push(FillStyle.parse(childElement));
					}
				case "strokes":
					for (childElement in element.elements)
					{
						shape.strokes.push(StrokeStyle.parse(childElement));
					}
			}
		}
		return shape;
	}
}
