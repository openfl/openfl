package openfl.display._internal;

#if !openfl_debug
@:fileXml(' tags="haxe,release" ')
@:noDebug
#end
@:access(openfl.display.DisplayObject)
@:access(openfl.display.DisplayObjectContainer)
class Context3DDisplayObjectContainer
{
	public static function renderDrawable(displayObjectContainer:DisplayObjectContainer, renderer:OpenGLRenderer):Void
	{
		displayObjectContainer.__cleanupRemovedChildren();

		if (!displayObjectContainer.__renderable || displayObjectContainer.__worldAlpha <= 0) return;

		Context3DDisplayObject.renderDrawable(displayObjectContainer, renderer);

		if (displayObjectContainer.__cacheBitmap != null && !displayObjectContainer.__isCacheBitmapRender) return;

		if (displayObjectContainer.__children.length > 0)
		{
			renderer.__pushMaskObject(displayObjectContainer);
			// renderer.filterManager.pushObject (this);

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
		}

		if (displayObjectContainer.__children.length > 0)
		{
			// renderer.filterManager.popObject (this);
			renderer.__popMaskObject(displayObjectContainer);
		}
	}

	public static function renderDrawableMask(displayObjectContainer:DisplayObjectContainer, renderer:OpenGLRenderer):Void
	{
		displayObjectContainer.__cleanupRemovedChildren();

		if (displayObjectContainer.__graphics != null)
		{
			// Context3DGraphics.renderMask (displayObjectContainer.__graphics, renderer);
			Context3DShape.renderMask(displayObjectContainer, renderer);
		}

		for (child in displayObjectContainer.__children)
		{
			renderer.__renderDrawableMask(child);
		}
	}
}
