package openfl.display; #if !flash #if !openfl_legacy


import openfl._internal.renderer.RenderSession;
import openfl.geom.ColorTransform;
import openfl.geom.Matrix;


interface IBitmapDrawable {
	
	var __worldTransform:Matrix;
	var __worldColorTransform:ColorTransform;
	
	private var __blendMode:BlendMode;
	private var __cacheAsBitmap:Bool;
	
	function __renderCairo (renderSession:RenderSession):Void;
	function __renderCairoMask (renderSession:RenderSession):Void;
	function __renderCanvas (renderSession:RenderSession):Void;
	function __renderCanvasMask (renderSession:RenderSession):Void;
	function __renderGL (renderSession:RenderSession):Void;
	function __updateChildren (transformOnly:Bool):Void;
	function __updateMatrices (?overrideTransform:Matrix = null):Void;
	
	function __updateMask (maskGraphics:Graphics):Void;
	
}


#else
typedef IBitmapDrawable = openfl._legacy.display.IBitmapDrawable;
#end
#else
typedef IBitmapDrawable = flash.display.IBitmapDrawable;
#end