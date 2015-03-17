package openfl._legacy.display; #if openfl_legacy


import openfl.geom.ColorTransform;
import openfl.geom.Matrix;
import openfl.geom.Rectangle;


interface IBitmapDrawable {
	
	
	@:noCompletion public function __drawToSurface (surface:Dynamic, matrix:Matrix, colorTransform:ColorTransform, blendMode:String, clipRect:Rectangle, smoothing:Bool):Void;
	
	
}


#end