package openfl.display; #if !flash #if !lime_legacy


import openfl._internal.renderer.RenderSession;
import openfl.geom.Matrix;


interface IBitmapDrawable {
	
	var __worldTransform:Matrix;
	
	function __renderCanvas (renderSession:RenderSession):Void;
	function __renderMask (renderSession:RenderSession):Void;
	function __updateChildren (transformOnly:Bool):Void;
	
}


#else
typedef IBitmapDrawable = openfl._v2.display.IBitmapDrawable;
#end
#else
typedef IBitmapDrawable = flash.display.IBitmapDrawable;
#end