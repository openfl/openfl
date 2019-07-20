package openfl.display;

#if !flash
import openfl.events.EventDispatcher;
import openfl.geom.ColorTransform;
import openfl.geom.Matrix;
import openfl.geom.Rectangle;
#if lime
import lime.graphics.RenderContextType;
#end

#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
@:allow(openfl._internal.renderer)
class DisplayObjectRenderer extends EventDispatcher
{
	@:noCompletion private var __allowSmoothing:Bool;
	@:noCompletion private var __blendMode:BlendMode;
	@:noCompletion private var __cleared:Bool;
	// @SuppressWarnings("checkstyle:Dynamic") @:noCompletion private var __context:#if lime RenderContext #else Dynamic #end;
	@:noCompletion private var __overrideBlendMode:BlendMode;
	@:noCompletion private var __roundPixels:Bool;
	@:noCompletion private var __stage:Stage;
	@:noCompletion private var __transparent:Bool;
	@SuppressWarnings("checkstyle:Dynamic") @:noCompletion private var __type:#if lime RenderContextType #else Dynamic #end;
	@:noCompletion private var __worldAlpha:Float;
	@:noCompletion private var __worldColorTransform:ColorTransform;
	@:noCompletion private var __worldTransform:Matrix;

	@:noCompletion private function new()
	{
		super();

		__allowSmoothing = true;
		__worldAlpha = 1;
	}

	@:noCompletion private function __clear():Void {}

	@:noCompletion private function __drawBitmapData(bitmapData:BitmapData, source:IBitmapDrawable, clipRect:Rectangle):Void {}

	@:noCompletion private function __render(object:IBitmapDrawable):Void {}

	@:noCompletion private function __resize(width:Int, height:Int):Void {}
}
#else
typedef DisplayObjectRenderer = Dynamic;
#end
