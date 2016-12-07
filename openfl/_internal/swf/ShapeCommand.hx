package openfl._internal.swf;


import openfl.display.CapsStyle;
import openfl.display.GradientType;
import openfl.display.JointStyle;
import openfl.display.InterpolationMethod;
import openfl.display.LineScaleMode;
import openfl.display.SpreadMethod;
import openfl.geom.Matrix;


enum ShapeCommand {
	
	BeginBitmapFill (bitmap:Int, matrix:Matrix, repeat:Bool, smooth:Bool);
	BeginFill (color:Int, alpha:Float);
	BeginGradientFill (fillType:GradientType, colors:Array<Int>, alphas:Array<Float>, ratios:Array<Int>, matrix:Matrix, spreadMethod:SpreadMethod, interpolationMethod:InterpolationMethod, focalPointRatio:Float);
	//CubicCurveTo (controlX1:Float, controlY1:Float, controlX2:Float, controlY2:Float, anchorX:Float, anchorY:Float);
	CurveTo (controlX:Float, controlY:Float, anchorX:Float, anchorY:Float);
	//DrawCircle (x:Float, y:Float, radius:Float);
	//DrawEllipse (x:Float, y:Float, width:Float, height:Float);
	//DrawRect (x:Float, y:Float, width:Float, height:Float);
	//DrawRoundRect (x:Float, y:Float, width:Float, height:Float, rx:Float, ry:Float);
	//DrawTiles (sheet:Tilesheet, tileData:Array<Float>, smooth:Bool, flags:Int, count:Int);
	//DrawTriangles (vertices:Vector<Float>, indices:Vector<Int>, uvtData:Vector<Float>, culling:TriangleCulling);
	EndFill;
	LineStyle (thickness:Null<Float>, color:Null<Int>, alpha:Null<Float>, pixelHinting:Null<Bool>, scaleMode:LineScaleMode, caps:CapsStyle, joints:JointStyle, miterLimit:Null<Float>);
	LineTo (x:Float, y:Float);
	MoveTo (x:Float, y:Float);
	
}