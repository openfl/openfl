package openfl.display;

#if !flash
import openfl._internal.renderer.DisplayObjectRendererType;
import openfl.events.EventDispatcher;
import openfl.geom.ColorTransform;
import openfl.geom.Matrix;
import openfl.geom.Rectangle;
import openfl.media.Video;

#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
@:allow(openfl._internal.renderer)
@:access(openfl.display.Bitmap)
@:access(openfl.display.BitmapData)
@:access(openfl.display.DisplayObject)
@:access(openfl.display.TileContainer)
@:access(openfl.display.Tilemap)
@:access(openfl.display.Timeline)
@:access(openfl.media.Video)
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
	@:noCompletion private var __type:DisplayObjectRendererType;
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

	@:noCompletion private function __enterFrame(displayObject:DisplayObject, deltaTime:Int):Void
	{
		for (child in displayObject.__childIterator(false))
		{
			switch (child.__type)
			{
				case BITMAP:
					var bitmap:Bitmap = cast child;
					if (bitmap.__bitmapData != null
						&& bitmap.__bitmapData.readable
						&& bitmap.__bitmapData.__getVersion() != bitmap.__imageVersion)
					{
						bitmap.__setRenderDirty();
					}

				case MOVIE_CLIP:
					var movieClip:MovieClip = cast child;
					if (movieClip.__timeline != null)
					{
						movieClip.__timeline.__enterFrame(deltaTime);
					}

				case TILEMAP:
					var tilemap:Tilemap = cast child;
					if (tilemap.__group.__dirty)
					{
						tilemap.__setRenderDirty();
					}

				case VIDEO:
					var video:Video = cast child;
					#if openfl_html5
					if (video.__renderable && video.__stream != null)
					{
						video.__setRenderDirty();
					}
					#end

				default:
			}
		}
	}

	@:noCompletion private function __render(object:IBitmapDrawable):Void {}

	@:noCompletion private function __resize(width:Int, height:Int):Void {}
}
#else
typedef DisplayObjectRenderer = Dynamic;
#end
