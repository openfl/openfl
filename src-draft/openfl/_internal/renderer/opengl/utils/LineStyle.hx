package openfl._internal.renderer.opengl.utils;

import openfl.display.CapsStyle;
import openfl.display.JointStyle;
import openfl.display.LineScaleMode;

@SuppressWarnings("checkstyle:FieldDocComment")
class LineStyle
{
	public var width:Float;
	public var color:Int;
	public var alpha:Null<Float>;

	public var scaleMode:LineScaleMode;
	public var caps:CapsStyle;
	public var joints:JointStyle;
	public var miterLimit:Float;

	public function new()
	{
		width = 0;
		color = 0;
		alpha = 1;
		scaleMode = LineScaleMode.NORMAL;
		caps = CapsStyle.ROUND;
		joints = JointStyle.ROUND;
		miterLimit = 3;
	}
}
