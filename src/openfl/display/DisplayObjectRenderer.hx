package openfl.display;

#if !flash
import openfl.events.EventDispatcher;
import openfl.geom.ColorTransform;
import openfl.geom.Matrix;
import openfl.geom.Rectangle;
#if lime
import lime.graphics.RenderContext;
import lime.graphics.RenderContextType;
#end

#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
@:access(openfl.geom.ColorTransform)
@:allow(openfl._internal.renderer)
@:allow(openfl.display)
@:allow(openfl.text)
class DisplayObjectRenderer extends EventDispatcher
{
	@:noCompletion private var __allowSmoothing:Bool;
	@:noCompletion private var __blendMode:BlendMode;
	@:noCompletion private var __cleared:Bool;
	@SuppressWarnings("checkstyle:Dynamic") @:noCompletion private var __context:#if lime RenderContext #else Dynamic #end;
	@:noCompletion private var __overrideBlendMode:BlendMode;
	@:noCompletion private var __roundPixels:Bool;
	@:noCompletion private var __stage:Stage;
	@:noCompletion private var __tempColorTransform:ColorTransform;
	@:noCompletion private var __transparent:Bool;
	@SuppressWarnings("checkstyle:Dynamic") @:noCompletion private var __type:#if lime RenderContextType #else Dynamic #end;
	@:noCompletion private var __worldAlpha:Float;
	@:noCompletion private var __worldColorTransform:ColorTransform;
	@:noCompletion private var __worldTransform:Matrix;

	@:noCompletion private function new()
	{
		super();

		__allowSmoothing = true;
		__tempColorTransform = new ColorTransform();
		__worldAlpha = 1;
	}

	@:noCompletion private function __clear():Void {}

	@:noCompletion private function __getAlpha(value:Float):Float
	{
		return value * __worldAlpha;
	}

	@:noCompletion private function __getColorTransform(value:ColorTransform):ColorTransform
	{
		if (__worldColorTransform != null)
		{
			__tempColorTransform.__copyFrom(__worldColorTransform);
			__tempColorTransform.__combine(value);
			return __tempColorTransform;
		}
		else
		{
			return value;
		}
	}

	@:noCompletion private function __popMask():Void {}

	@:noCompletion private function __popMaskObject(object:DisplayObject, handleScrollRect:Bool = true):Void {}

	@:noCompletion private function __popMaskRect():Void {}

	@:noCompletion private function __pushMask(mask:DisplayObject):Void {}

	@:noCompletion private function __pushMaskObject(object:DisplayObject, handleScrollRect:Bool = true):Void {}

	@:noCompletion private function __pushMaskRect(rect:Rectangle, transform:Matrix):Void {}

	@:noCompletion private function __render(object:IBitmapDrawable):Void {}

	@:noCompletion private function __resize(width:Int, height:Int):Void {}

	@:noCompletion private function __setBlendMode(value:BlendMode):Void {}
}
#else
typedef DisplayObjectRenderer = Dynamic;
#end
