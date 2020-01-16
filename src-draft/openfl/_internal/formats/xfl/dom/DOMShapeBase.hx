package openfl._internal.formats.xfl.dom;

import openfl._internal.formats.xfl.fill.FillStyle;
import openfl._internal.formats.xfl.stroke.StrokeStyle;

class DOMShapeBase
{
	public var fills:Array<FillStyle>;
	public var strokes:Array<StrokeStyle>;

	private function new()
	{
		fills = new Array<FillStyle>();
		strokes = new Array<StrokeStyle>();
	}
}
