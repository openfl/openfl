package openfl.display._internal;

@:access(openfl.display.DisplayObject)
@:access(openfl.display.DisplayObjectContainer)
class DOMDisplayObjectContainer
{
	public static function renderDrawable(displayObjectContainer:DisplayObjectContainer, renderer:DOMRenderer):Void
	{
		for (orphan in displayObjectContainer.__removedChildren)
		{
			if (orphan.stage == null)
			{
				renderer.__renderDrawable(orphan);
			}
		}

		displayObjectContainer.__cleanupRemovedChildren();

		DOMDisplayObject.renderDrawable(displayObjectContainer, renderer);

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
	}

	public static function renderDrawableClear(displayObjectContainer:DisplayObjectContainer, renderer:DOMRenderer):Void
	{
		for (orphan in displayObjectContainer.__removedChildren)
		{
			if (orphan.stage == null)
			{
				renderer.__renderDrawableClear(orphan);
			}
		}

		displayObjectContainer.__cleanupRemovedChildren();

		for (child in displayObjectContainer.__children)
		{
			renderer.__renderDrawableClear(child);
		}
	}
}
