package openfl.display._internal;

@:access(openfl.display.DisplayObject)
@:access(openfl.display.DisplayObjectContainer)
class CanvasDisplayObjectContainer
{
	public static function renderDrawable(displayObjectContainer:DisplayObjectContainer, renderer:CanvasRenderer):Void
	{
		displayObjectContainer.__cleanupRemovedChildren();

		if (!displayObjectContainer.__renderable
			|| displayObjectContainer.__worldAlpha <= 0
			|| (displayObjectContainer.mask != null
				&& (displayObjectContainer.mask.width <= 0 || displayObjectContainer.mask.height <= 0))) return;

		#if !neko
		CanvasDisplayObject.renderDrawable(displayObjectContainer, renderer);

		if (displayObjectContainer.__cacheBitmap != null && !displayObjectContainer.__isCacheBitmapRender) return;

		renderer.__pushMaskObject(displayObjectContainer);

		if (renderer.__stage != null)
		{
			for (child in displayObjectContainer.__children)
			{
				renderer.__renderDrawable(child);
				child.__renderDirty = false;
			}

			displayObjectContainer.__renderDirty = false;
		}
		else
		{
			for (child in displayObjectContainer.__children)
			{
				renderer.__renderDrawable(child);
			}
		}

		renderer.__popMaskObject(displayObjectContainer);
		#end
	}

	public static function renderDrawableMask(displayObjectContainer:DisplayObjectContainer, renderer:CanvasRenderer):Void
	{
		displayObjectContainer.__cleanupRemovedChildren();

		if (displayObjectContainer.__graphics != null)
		{
			CanvasGraphics.renderMask(displayObjectContainer.__graphics, renderer);
		}

		for (child in displayObjectContainer.__children)
		{
			renderer.__renderDrawableMask(child);
		}
	}
}
