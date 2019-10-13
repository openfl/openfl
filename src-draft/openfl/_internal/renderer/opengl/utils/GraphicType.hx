package openfl._internal.renderer.opengl.utils;

import openfl.display.TriangleCulling;
import openfl.Vector;

enum GraphicType
{
	Polygon;
	Rectangle(rounded:Bool);
	Circle;
	Ellipse;
	// DrawTriangles(vertices:Vector<Float>, indices:Vector<Int>, uvtData:Vector<Float>, culling:TriangleCulling, colors:Vector<Int>, blendMode:Int);
	// DrawTiles(sheet:Tilesheet, tileData:Array<Float>, smooth:Bool, flags:Int, count:Int);
	// OverrideMatrix(matrix:Matrix);
}
