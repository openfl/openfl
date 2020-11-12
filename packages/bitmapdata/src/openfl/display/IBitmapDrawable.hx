package openfl.display;

#if !flash
import openfl.display._internal.IBitmapDrawableType;
import openfl.geom.ColorTransform;
import openfl.geom.Matrix;
import openfl.geom.Rectangle;

interface IBitmapDrawable
{
	@:noCompletion private var __blendMode:BlendMode;
	@:noCompletion private var __drawableType:IBitmapDrawableType;
	@:noCompletion private var __isMask:Bool;
	@:noCompletion private var __renderable:Bool;
	@:noCompletion private var __renderTransform:Matrix;
	@:noCompletion private var __transform:Matrix;
	@:noCompletion private var __worldAlpha:Float;
	@:noCompletion private var __worldColorTransform:ColorTransform;
	@:noCompletion private var __worldTransform:Matrix;
	@:noCompletion private function __getBounds(rect:Rectangle, matrix:Matrix):Void;
	@:noCompletion private function __update(transformOnly:Bool, updateChildren:Bool):Void;
	@:noCompletion private function __updateTransforms(overrideTransform:Matrix = null):Void;
	@:noCompletion private var __mask:DisplayObject;
	@:noCompletion private var __scrollRect:Rectangle;
}
#else
typedef IBitmapDrawable = flash.display.IBitmapDrawable;
#end
