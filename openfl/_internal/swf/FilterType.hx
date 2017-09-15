package openfl._internal.swf;


enum FilterType {
	
	BlurFilter (blurX:Float, blurY:Float, quality:Int);
	ColorMatrixFilter (matrix:Array<Float>);
	DropShadowFilter (distance:Float, angle:Float, color:Int, alpha:Float, blurX:Float, blurY:Float, strength:Float, quality:Int, inner:Bool, knockout:Bool, hideObject:Bool);
	GlowFilter (color:Int, alpha:Float, blurX:Float, blurY:Float, strength:Float, quality:Int, inner:Bool, knockout:Bool);
	
}