// import openfl._internal.renderer.DisplayObjectRendererType;
import EventDispatcher from "../events/EventDispatcher";
import ColorTransfrom from "../geom/ColorTransform";
import Matrix from "../geom/Matrix";
import Rectangle from "../geom/Rectangle";
import Video from "../media/Video";

namespace openfl.display
{
	export class DisplayObjectRenderer extends EventDispatcher
	{
		protected __allowSmoothing: boolean;
		protected __blendMode: BlendMode;
		protected __cleared: boolean;
		// @SuppressWarnings("checkstyle:Dynamic") protected __context:#if lime RenderContext #else Dynamic #end;
		protected __overrideBlendMode: BlendMode;
		protected __roundPixels: boolean;
		protected __stage: Stage;
		protected __transparent: boolean;
		protected __type: DisplayObjectRendererType;
		protected __worldAlpha: number;
		protected __worldColorTransform: ColorTransform;
		protected __worldTransform: Matrix;

		protected constructor()
		{
			super();

			__allowSmoothing = true;
			__worldAlpha = 1;
		}

		protected __clear(): void { }

		protected __drawBitmapData(bitmapData: BitmapData, source: IBitmapDrawable, clipRect: Rectangle): void { }

		protected __enterFrame(displayObject: DisplayObject, deltaTime: number): void
		{
			for (child in displayObject.__childIterator(false))
			{
				switch (child.__type)
				{
					case BITMAP:
						var bitmap: Bitmap = cast child;
						if (bitmap.__bitmapData != null
							&& bitmap.__bitmapData.readable
							&& bitmap.__bitmapData.__getVersion() != bitmap.__imageVersion)
						{
							bitmap.__setRenderDirty();
						}

					case MOVIE_CLIP:
						var movieClip: MovieClip = cast child;
						if (movieClip.__timeline != null)
						{
							movieClip.__timeline.__enterFrame(deltaTime);
						}

					case TILEMAP:
						var tilemap: Tilemap = cast child;
						if (tilemap.__group.__dirty)
						{
							tilemap.__setRenderDirty();
						}

					case VIDEO:
						var video: Video = cast child;
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

		protected __render(object: IBitmapDrawable): void { }

		protected __resize(width: number, height: number): void { }
	}
}

export default openfl.display.DisplayObjectRenderer;
