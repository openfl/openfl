package openfl._internal.renderer.opengl.utils;

import openfl.display3D.Context3D;
import openfl.display.CapsStyle;
import openfl.display.Graphics;
import openfl.display.JointStyle;
import openfl.display.LineScaleMode;

@SuppressWarnings("checkstyle:FieldDocComment")
class DrawPath
{
	public var line:LineStyle;
	public var fill:FillType;
	public var fillIndex:Int = 0;
	public var isRemovable:Bool = true;
	public var winding:WindingRule = WindingRule.EVEN_ODD;

	public var points:Array<Float> = [];

	public var type:GraphicType = Polygon;

	public function new()
	{
		line = new LineStyle();
		fill = None;
	}

	public function update(line:LineStyle, fill:FillType, fillIndex:Int, winding:WindingRule):Void
	{
		updateLine(line);
		this.fill = fill;
		this.fillIndex = fillIndex;
		this.winding = winding;
	}

	public function updateLine(line:LineStyle):Void
	{
		this.line.width = line.width;
		this.line.color = line.color;
		this.line.alpha = line.alpha == null ? 1 : line.alpha;
		this.line.scaleMode = line.scaleMode == null ? LineScaleMode.NORMAL : line.scaleMode;
		this.line.caps = line.caps == null ? CapsStyle.ROUND : line.caps;
		this.line.joints = line.joints == null ? JointStyle.ROUND : line.joints;
		this.line.miterLimit = line.miterLimit;
	}

	public static function getStack(object:Graphics, context3D:Context3D):GLStack
	{
		return PathBuilder.build(object, context3D);
	}
}
