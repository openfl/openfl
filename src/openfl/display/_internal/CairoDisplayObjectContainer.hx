package openfl.display._internal;

#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
@:access(openfl.display.DisplayObject)
@:access(openfl.display.DisplayObjectContainer)
class CairoDisplayObjectContainer
{
	public static inline function renderDrawable(displayObjectContainer:DisplayObjectContainer, renderer:CairoRenderer):Void
	{
		#if lime_cairo
		displayObjectContainer.__cleanupRemovedChildren();

		if (!displayObjectContainer.__renderable || displayObjectContainer.__worldAlpha <= 0) return;

		CairoDisplayObject.renderDrawable(displayObjectContainer, renderer);

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

	public static inline function renderDrawableMask(displayObjectContainer:DisplayObjectContainer, renderer:CairoRenderer):Void
	{
		#if lime_cairo
		displayObjectContainer.__cleanupRemovedChildren();

		if (displayObjectContainer.__graphics != null)
		{
			CairoGraphics.renderMask(displayObjectContainer.__graphics, renderer);
		}

		for (child in displayObjectContainer.__children)
		{
			renderer.__renderDrawableMask(child);
		}
		#end
	}
}
