package openfl._internal.renderer.opengl.utils;

import openfl.display.BitmapData;
import openfl.geom.Matrix;

enum FillType
{
	None;
	Color(color:Int, alpha:Float);
	Texture(bitmap:BitmapData, matrix:Matrix, repeat:Bool, smooth:Bool);
	Gradient;
}
