package openfl.display; #if !openfl_legacy


import openfl._internal.renderer.RenderSession;
import openfl.geom.ColorTransform;
import openfl.geom.Matrix;


interface IBitmapDrawable {

	public var __worldTransform:Matrix;

	private var __blendMode:BlendMode;
	private var __cacheAsBitmap:Bool;

	public function __renderGL (renderSession:RenderSession):Void;
	public function __updateChildren (transformOnly:Bool):Void;
	public function __updateTransforms ():Void;

}


#else
typedef IBitmapDrawable = openfl._legacy.display.IBitmapDrawable;
#end
