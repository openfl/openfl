package openfl.display;

import openfl._internal.renderer.DisplayObjectRendererType;
import openfl.display._DisplayObject;
import openfl.events.EventDispatcher;
import openfl.events._EventDispatcher;
import openfl.geom.ColorTransform;
import openfl.geom.Matrix;
import openfl.geom.Rectangle;
import openfl.media.Video;
import openfl.media._Video;

#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
@:noCompletion
class _DisplayObjectRenderer extends _EventDispatcher
{
	public var __allowSmoothing:Bool;
	public var __blendMode:BlendMode;
	public var __cleared:Bool;
	// @SuppressWarnings("checkstyle:Dynamic") public var __context:#if lime RenderContext #else Dynamic #end;
	public var __overrideBlendMode:BlendMode;
	public var __roundPixels:Bool;
	public var __stage:Stage;
	public var __transparent:Bool;
	public var __type:DisplayObjectRendererType;
	public var __worldAlpha:Float;
	public var __worldColorTransform:ColorTransform;
	public var __worldTransform:Matrix;

	private var displayObjectRenderer:DisplayObjectRenderer;

	public function new(displayObjectRenderer:DisplayObjectRenderer)
	{
		this.displayObjectRenderer = displayObjectRenderer;

		super(displayObjectRenderer);

		__allowSmoothing = true;
		__worldAlpha = 1;
	}

	public function __clear():Void {}

	public function __drawBitmapData(bitmapData:BitmapData, source:IBitmapDrawable, clipRect:Rectangle):Void {}

	public function __enterFrame(displayObject:DisplayObject, deltaTime:Int):Void
	{
		for (child in (displayObject._ : _DisplayObject).__childIterator(false))
		{
			switch ((child._ : _DisplayObject).__type)
			{
				case BITMAP:
					var bitmap:Bitmap = cast child;
					if ((bitmap._ : _Bitmap).__bitmapData != null
						&& (bitmap._ : _Bitmap).__bitmapData.readable
							&& ((bitmap._ : _Bitmap).__bitmapData._ : _BitmapData).__getVersion() != (bitmap._ : _Bitmap).__imageVersion)
					{
						(bitmap._ : _Bitmap).__setRenderDirty();
					}

				case MOVIE_CLIP:
					var movieClip:MovieClip = cast child;
					if ((movieClip._ : _MovieClip).__timeline != null)
					{
						((movieClip._ : _MovieClip).__timeline._ : _Timeline).__enterFrame(deltaTime);
					}

				case TILEMAP:
					var tilemap:Tilemap = cast child;
					if (((tilemap._ : _Tilemap).__group._ : _TileContainer).__dirty)
					{
						(tilemap._ : _Tilemap).__setRenderDirty();
					}

				case VIDEO:
					var video:Video = cast child;
					#if openfl_html5
					if ((video._ : _Video).__renderable && (video._ : _Video).__stream != null)
					{
						(video._ : _Video).__setRenderDirty();
					}
					#end

				default:
			}
		}
	}

	public function __render(object:IBitmapDrawable):Void {}

	public function __resize(width:Int, height:Int):Void {}
}
