package openfl._internal.formats.xfl.dom;

import openfl.geom.Matrix;
import openfl.geom.Point;
import haxe.xml.Fast;

class DOMDynamicText
{
	public static var TYPE_NONE:Int = 0;
	public static var TYPE_DYNAMIC:Int = 1;
	public static var TYPE_INPUT:Int = 2;

	public var height:Float;
	public var isSelectable:Bool;
	public var multiLine:Bool;
	public var left:Float;
	public var top:Float;
	public var matrix:Matrix;
	public var name:String;
	public var textRuns:Array<DOMTextRun>;
	public var width:Float;
	public var type:Int;

	public function new()
	{
		textRuns = new Array<DOMTextRun>();
	}

	public static function parse(xml:Fast, type:Int):DOMDynamicText
	{
		var dynamicText:DOMDynamicText = new DOMDynamicText();
		dynamicText.type = type;
		dynamicText.height = Std.parseFloat(xml.att.height);
		dynamicText.width = Std.parseFloat(xml.att.width);
		if (xml.has.name) dynamicText.name = xml.att.name;
		dynamicText.isSelectable = xml.has.isSelectable == false || xml.att.isSelectable == "true";
		dynamicText.multiLine = xml.has.lineType == true && xml.att.lineType == "multiline";
		dynamicText.left = (xml.has.left == true) ? Std.parseFloat(xml.att.left) : 0.0;
		dynamicText.top = (xml.has.top == true) ? Std.parseFloat(xml.att.top) : 0.0;
		for (element in xml.elements)
		{
			switch (element.name)
			{
				case "matrix":
					dynamicText.matrix = openfl._internal.formats.xfl.geom.Matrix.parse(element.elements.next());
				case "textRuns":
					for (childElement in element.elements)
					{
						dynamicText.textRuns.push(DOMTextRun.parse(childElement));
					}
			}
		}
		if (dynamicText.matrix != null)
		{
			dynamicText.left = dynamicText.matrix.deltaTransformPoint(new Point(dynamicText.left, 0.0)).x;
			dynamicText.top = dynamicText.matrix.deltaTransformPoint(new Point(0.0, dynamicText.top)).y;
		}
		return dynamicText;
	}
}
