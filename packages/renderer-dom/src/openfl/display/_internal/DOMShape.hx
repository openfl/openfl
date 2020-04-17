package openfl.display._internal;

#if openfl_html5
import openfl.display._internal.CanvasGraphics;
import openfl.display.DisplayObject;

@:access(openfl.display.DisplayObject)
@:access(openfl.display.Graphics)
@:access(openfl.geom.Matrix)
@:access(openfl.geom.Rectangle)
@SuppressWarnings("checkstyle:FieldDocComment")
class DOMShape
{
	public static function clear(shape:DisplayObject, renderer:DOMRenderer):Void
	{
		#if openfl_html5
		if (shape.__renderData.canvas != null)
		{
			renderer.element.removeChild(shape.__renderData.canvas);
			shape.__renderData.canvas = null;
			shape.__renderData.style = null;
		}
		#end
	}

	public static inline function render(shape:DisplayObject, renderer:DOMRenderer):Void
	{
		#if openfl_html5
		var graphics = shape.__graphics;

		if (shape.stage != null && shape.__worldVisible && shape.__renderable && graphics != null)
		{
			CanvasGraphics.render(graphics, renderer.__canvasRenderer);

			if (graphics.__softwareDirty || shape.__worldAlphaChanged || (shape.__renderData.canvas != graphics.__renderData.canvas))
			{
				if (graphics.__renderData.canvas != null)
				{
					if (shape.__renderData.canvas != graphics.__renderData.canvas)
					{
						if (shape.__renderData.canvas != null)
						{
							renderer.element.removeChild(shape.__renderData.canvas);
						}

						shape.__renderData.canvas = graphics.__renderData.canvas;
						shape.__renderData.context = graphics.__renderData.context;

						renderer.__initializeElement(shape, shape.__renderData.canvas);
					}
				}
				else
				{
					clear(shape, renderer);
				}
			}

			if (shape.__renderData.canvas != null)
			{
				renderer.__pushMaskObject(shape);

				var cacheTransform = shape.__renderTransform;
				shape.__renderTransform = graphics.__worldTransform;

				if (graphics.__transformDirty)
				{
					graphics.__transformDirty = false;
					shape.__renderTransformChanged = true;
				}

				renderer.__updateClip(shape);
				renderer.__applyStyle(shape, true, true, true);

				shape.__renderTransform = cacheTransform;

				renderer.__popMaskObject(shape);
			}
		}
		else
		{
			clear(shape, renderer);
		}
		#end
	}
}
#end
