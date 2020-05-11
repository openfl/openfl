package openfl.display;

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
@:noCompletion
class _DisplayObjectRenderer extends _EventDispatcher
{
	private var __allowSmoothing:Bool;
	private var __blendMode:BlendMode;
	private var __cleared:Bool;
	// @SuppressWarnings("checkstyle:Dynamic") private var __context:#if lime RenderContext #else Dynamic #end;
	private var __overrideBlendMode:BlendMode;
	private var __roundPixels:Bool;
	private var __stage:Stage;
	private var __transparent:Bool;
	private var __type:DisplayObjectRendererType;
	private var __worldAlpha:Float;
	private var __worldColorTransform:ColorTransform;
	private var __worldTransform:Matrix;

	public function new(displayObjectRenderer:DisplayObjectRenderer)
	{
		super(displayObjectRenderer);

		__allowSmoothing = true;
		__worldAlpha = 1;
	}

	private function __clear():Void {}

	private function __drawBitmapData(bitmapData:BitmapData, source:IBitmapDrawable, clipRect:Rectangle):Void {}

	private function __enterFrame(displayObject:DisplayObject, deltaTime:Int):Void
	{
		for (child in displayObject._.__childIterator(false))
		{
			switch (child._.__type)
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

	private function __render(object:IBitmapDrawable):Void {}

	private function __resize(width:Int, height:Int):Void {}
}
