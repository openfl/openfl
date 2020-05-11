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
		if (shape._.__renderData.canvas != null)
		{
			renderer.element.removeChild(shape._.__renderData.canvas);
			shape._.__renderData.canvas = null;
			shape._.__renderData.style = null;
		}
		#end
	}

	public static inline function render(shape:DisplayObject, renderer:DOMRenderer):Void
	{
		#if openfl_html5
		var graphics = shape._.__graphics;

		if (shape.stage != null && shape._.__worldVisible && shape._.__renderable && graphics != null)
		{
			CanvasGraphics.render(graphics, renderer._.__canvasRenderer);

			if (graphics._.__softwareDirty
				|| shape._.__worldAlphaChanged
				|| (shape._.__renderData.canvas != graphics._.__renderData.canvas))
			{
				if (graphics._.__renderData.canvas != null)
				{
					if (shape._.__renderData.canvas != graphics._.__renderData.canvas)
					{
						if (shape._.__renderData.canvas != null)
						{
							renderer.element.removeChild(shape._.__renderData.canvas);
						}

						shape._.__renderData.canvas = graphics._.__renderData.canvas;
						shape._.__renderData.context = graphics._.__renderData.context;

						renderer._.__initializeElement(shape, shape._.__renderData.canvas);
					}
				}
				else
				{
					clear(shape, renderer);
				}
			}

			if (shape._.__renderData.canvas != null)
			{
				renderer._.__pushMaskObject(shape);

				var cacheTransform = shape._.__renderTransform;
				shape._.__renderTransform = graphics._.__worldTransform;

				if (graphics._.__transformDirty)
				{
					graphics._.__transformDirty = false;
					shape._.__renderTransformChanged = true;
				}

				renderer._.__updateClip(shape);
				renderer._.__applyStyle(shape, true, true, true);

				shape._.__renderTransform = cacheTransform;

				renderer._.__popMaskObject(shape);
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
