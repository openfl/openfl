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
		if ((shape._ : _Shape).__renderData.canvas != null)
		{
			renderer.element.removeChild((shape._ : _Shape).__renderData.canvas);
			(shape._ : _Shape).__renderData.canvas = null;
			(shape._ : _Shape).__renderData.style = null;
		}
		#end
	}

	public static inline function render(shape:DisplayObject, renderer:DOMRenderer):Void
	{
		#if openfl_html5
		var graphics = (shape._ : _Shape).__graphics;

		if (shape.stage != null && (shape._ : _Shape).__worldVisible && (shape._ : _Shape).__renderable && graphics != null)
		{
			CanvasGraphics.render(graphics, (renderer._ : _DOMRenderer).__canvasRenderer);

			if ((graphics._ : _Graphics).__softwareDirty
				|| (shape._ : _Shape).__worldAlphaChanged
					|| ((shape._ : _Shape).__renderData.canvas != (graphics._ : _Graphics).__renderData.canvas))
			{
				if ((graphics._ : _Graphics).__renderData.canvas != null)
				{
					if ((shape._ : _Shape).__renderData.canvas != (graphics._ : _Graphics).__renderData.canvas)
					{
						if ((shape._ : _Shape).__renderData.canvas != null)
						{
							renderer.element.removeChild((shape._ : _Shape).__renderData.canvas);
						}

							(shape._ : _Shape).__renderData.canvas = (graphics._ : _Graphics).__renderData.canvas;
						(shape._ : _Shape).__renderData.context = (graphics._ : _Graphics).__renderData.context;

						(renderer._ : _DOMRenderer).__initializeElement(shape, (shape._ : _Shape).__renderData.canvas);
					}
				}
				else
				{
					clear(shape, renderer);
				}
			}

			if ((shape._ : _Shape).__renderData.canvas != null)
			{
				(renderer._ : _DOMRenderer).__pushMaskObject(shape);

				var cacheTransform = (shape._ : _Shape).__renderTransform;
				(shape._ : _Shape).__renderTransform = (graphics._ : _Graphics).__worldTransform;

				if ((graphics._ : _Graphics).__transformDirty)
				{
					(graphics._ : _Graphics).__transformDirty = false;
					(shape._ : _Shape).__renderTransformChanged = true;
				}

					(renderer._ : _DOMRenderer).__updateClip(shape);
				(renderer._ : _DOMRenderer).__applyStyle(shape, true, true, true);

				(shape._ : _Shape).__renderTransform = cacheTransform;

				(renderer._ : _DOMRenderer).__popMaskObject(shape);
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
