package openfl.display._internal;

import openfl.display._internal.CanvasGraphics;
import openfl.display.DisplayObject;
import openfl.display.DOMRenderer;

@:access(openfl.display.DisplayObject)
@:access(openfl.display.Graphics)
@:access(openfl.geom.Matrix)
@:access(openfl.geom.Rectangle)
@SuppressWarnings("checkstyle:FieldDocComment")
class DOMShape
{
	public static function clear(shape:DisplayObject, renderer:DOMRenderer):Void
	{
		#if (js && html5)
		if (shape.__canvas != null)
		{
			renderer.element.removeChild(shape.__canvas);
			shape.__canvas = null;
			shape.__style = null;
		}
		#end
	}

	public static inline function render(shape:DisplayObject, renderer:DOMRenderer):Void
	{
		#if (js && html5)
		var graphics = shape.__graphics;

		if (shape.stage != null && shape.__worldVisible && shape.__renderable && graphics != null)
		{
			CanvasGraphics.render(graphics, renderer.__canvasRenderer);

			if (graphics.__softwareDirty || shape.__worldAlphaChanged || (shape.__canvas != graphics.__canvas))
			{
				if (graphics.__canvas != null)
				{
					if (shape.__canvas != graphics.__canvas)
					{
						if (shape.__canvas != null)
						{
							renderer.element.removeChild(shape.__canvas);
						}

						shape.__canvas = graphics.__canvas;
						shape.__context = graphics.__context;

						renderer.__initializeElement(shape, shape.__canvas);
					}
				}
				else
				{
					clear(shape, renderer);
				}
			}

			if (shape.__canvas != null)
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
