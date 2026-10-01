package openfl.display;

#if !flash
import openfl.display._internal.Context3DGraphics;
import openfl.display.Bitmap;
import openfl.display.DisplayObject;
import openfl.display.Tilemap;
import openfl.events.EventDispatcher;
import openfl.events.RenderEvent;
import openfl.filters.ShaderFilter;
import openfl.geom.ColorTransform;
import openfl.geom.Matrix;
import openfl.geom.Point;
import openfl.geom.Rectangle;
import openfl.text.TextField;
#if lime
import lime._internal.graphics.ImageCanvasUtil; // TODO
import lime.graphics.cairo.Cairo;
import lime.graphics.RenderContext;
import lime.graphics.RenderContextType;
#end

#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
@:access(openfl.display._internal.Context3DGraphics)
@:access(lime.graphics.ImageBuffer)
@:access(openfl.display.Bitmap)
@:access(openfl.display.BitmapData)
@:access(openfl.display.DisplayObject)
@:access(openfl.display.Graphics)
@:access(openfl.display.Stage)
@:access(openfl.display.Tilemap)
@:access(openfl.display3D.Context3D)
@:access(openfl.events.RenderEvent)
@:access(openfl.filters.BitmapFilter)
@:access(openfl.geom.ColorTransform)
@:access(openfl.geom.Rectangle)
@:access(openfl.geom.Transform)
@:access(openfl.text.TextField)
@:allow(openfl.display._internal)
@:allow(openfl.display)
@:allow(openfl.text)
class DisplayObjectRenderer extends EventDispatcher
{
	@:noCompletion private var __allowSmoothing:Bool;
	@:noCompletion private var __blendMode:BlendMode;
	@:noCompletion private var __cleared:Bool;
	@SuppressWarnings("checkstyle:Dynamic") @:noCompletion private var __context:#if lime RenderContext #else Dynamic #end;
	@:noCompletion private var __overrideBlendMode:BlendMode;
	@:noCompletion private var __groupBlendMode:BlendMode;
	@:noCompletion private var __coverageOnly:Bool;
	// the group whose touches are tracked (see __touch); null at the top of a render, where every
	// pixel counts as touched
	@:noCompletion private var __touchedGroup:DisplayObject;
	@:noCompletion private var __touchedBuilt:Bool;
	// how many groups the current object is inside; a cache bitmap's renderer starts at the depth it
	// is drawn at, since the scratch buffers kept per depth are shared
	@:noCompletion private var __layerDepth:Int = 0;
	// the current buffer's level, and whether it has content yet (see __openBuffer)
	@:noCompletion private var __bufferLevel:Int = 0;
	@:noCompletion private var __bufferHasContent:Bool = false;
	@:noCompletion private var __pixelRatio:Float;
	@:noCompletion private var __roundPixels:Bool;
	@:noCompletion private var __stage:Stage;
	@:noCompletion private var __tempColorTransform:ColorTransform;

	/**
		Whether the surface being drawn into has an alpha channel. `BitmapData.draw` sets this to false
		when it draws into an opaque bitmap. When the stage is rendered, the stage's own `transparent`
		setting is used instead.
	**/
	@:noCompletion private var __transparent:Bool = true;

	@SuppressWarnings("checkstyle:Dynamic") @:noCompletion private var __type:#if lime RenderContextType #else Dynamic #end;
	@:noCompletion private var __worldAlpha:Float;
	@:noCompletion private var __worldColorTransform:ColorTransform;
	@:noCompletion private var __worldTransform:Matrix;

	/**
		Records that `displayObject` was drawn: the current buffer now has content (see `__openBuffer`),
		and the object's coverage is added to the group's touched buffer, if one is kept.

		Flash tracks how much of each pixel of a group earlier objects have covered. SUBTRACT and INVERT
		draw the object as it is over uncovered pixels and apply the mode over covered ones, even where
		the backdrop has become transparent again; ERASE and ALPHA do so only where `__cutterShowsAsIs`
		holds. A group builds its buffer the first time one of these needs it (see `__ensureTouched`);
		outside any group there is none, and every pixel counts as covered.

		A leaf adds its own coverage, a container's graphics are added by `__touchGraphics`, and with
		`subtree` an object rendered as a group of its own is added as a whole.
	**/
	@:noCompletion private function __touch(displayObject:DisplayObject, subtree:Bool = false):Void
	{
		if (!__countsAsTouching(displayObject)) return;
		if (subtree)
		{
			// a group counts as drawn into the buffer through __closeBuffer, if anything was drawn into it
			if (__touchedBuilt) __walkTouched(displayObject, null);
		}
		else if (displayObject.__children == null)
		{
			__bufferHasContent = true;
			if (__touchedBuilt) __drawTouched(displayObject, false);
		}
	}

	/**
		The mode `displayObject` is composited with: the one given to `BitmapData.draw`, or its world
		mode. The mode of the group being rendered counts as NORMAL, since the group's composite
		applies it.
	**/
	@:noCompletion private function __effectiveBlendMode(displayObject:DisplayObject):BlendMode
	{
		var blendMode = __overrideBlendMode != null ? __overrideBlendMode : displayObject.__worldBlendMode;
		return blendMode == __groupBlendMode ? NORMAL : blendMode;
	}

	/**
		Whether `displayObject` is composited with ERASE or ALPHA (see `__effectiveBlendMode`).
	**/
	@:noCompletion private function __isCutter(displayObject:DisplayObject):Bool
	{
		var blendMode = __effectiveBlendMode(displayObject);
		return blendMode == ERASE || blendMode == ALPHA;
	}

	/**
		Whether `displayObject` counts as drawn for `__touch`: visible, and not a cutter unless cutters
		follow the touched model here (see `__cutterShowsAsIs`).
	**/
	@:noCompletion private function __countsAsTouching(displayObject:DisplayObject):Bool
	{
		if (!displayObject.__renderable || displayObject.__worldAlpha <= 0) return false;
		return !__isCutter(displayObject) || __cutterShowsAsIs();
	}

	/**
		Records a container's own graphics as drawn, before its children (see `__touch`).
	**/
	@:noCompletion private function __touchGraphics(displayObject:DisplayObject):Void
	{
		if (!__countsAsTouching(displayObject)) return;
		var graphics = displayObject.__graphics;
		if (graphics == null || graphics.__commands.length == 0) return;
		__bufferHasContent = true;
		if (__touchedBuilt) __drawTouched(displayObject, true);
	}

	/**
		Draws the coverage of `displayObject` and its descendants into the touched buffer in drawing
		order, stopping at `stopAt`, and returns whether it was reached. It fills a buffer built after
		the fact (see `__ensureTouched`) and adds a whole group (see `__touch`). Objects that do not
		count as touching are skipped with their children (see `__countsAsTouching`).
	**/
	@:noCompletion private function __walkTouched(displayObject:DisplayObject, stopAt:DisplayObject):Bool
	{
		if (displayObject == stopAt) return true;
		if (!__countsAsTouching(displayObject)) return false;
		var children = displayObject.__children;
		if (children == null)
		{
			__drawTouched(displayObject, false);
			return false;
		}
		if (displayObject.__graphics != null) __drawTouched(displayObject, true);
		for (child in children)
		{
			if (__walkTouched(child, stopAt)) return true;
		}
		return false;
	}

	/**
		Draws what a leaf covers into the touched buffer, or with `graphicsOnly` a container's own
		graphics. Each renderer implements it for its own kind of buffer.
	**/
	@:noCompletion private function __drawTouched(displayObject:DisplayObject, graphicsOnly:Bool):Void {}

	/**
		Whether drawing goes straight onto the stage, rather than into a group, a cache bitmap or a
		`BitmapData.draw` bitmap. Flash does not draw ERASE or ALPHA objects there at all.
	**/
	@:noCompletion private inline function __drawsOntoStage():Bool
	{
		return __bufferLevel == 0;
	}

	/**
		Whether ERASE and ALPHA follow the touched model here (see `__touch`) instead of simply cutting.
		On screen Flash does so only in a buffer nested inside one that has content
		(see `__openBuffer`). The bitmap of `BitmapData.draw` counts as a buffer with content, so every
		group inside a draw call does.
	**/
	@:noCompletion private inline function __cutterShowsAsIs():Bool
	{
		return __bufferLevel >= 2;
	}

	/**
		Starts a render at level 0 on the stage, or at level 1 with content when drawing into a bitmap
		(`BitmapData.draw` or a cache bitmap).
	**/
	@:noCompletion private function __resetBufferLevel():Void
	{
		var stage = __stage != null && __stage.__renderer == this;
		__bufferLevel = stage ? 0 : 1;
		__bufferHasContent = !stage;
	}

	/**
		Enters a group: it gets the next level when the current buffer is the stage or has content, and
		shares the current level when that buffer is still empty. The caller keeps the old state for
		`__closeBuffer`.
	**/
	@:noCompletion private function __openBuffer():Void
	{
		if (__bufferLevel == 0 || __bufferHasContent) __bufferLevel++;
		__bufferHasContent = false;
	}

	/**
		Leaves a group and restores the outer buffer's `level`. The outer buffer has content if it had
		some before (`hadContent`) or the group got any.
	**/
	@:noCompletion private function __closeBuffer(level:Int, hadContent:Bool):Void
	{
		__bufferHasContent = hadContent || __bufferHasContent;
		__bufferLevel = level;
	}

	/**
		Whether a shape should also render its coverage: a second copy of its fills, drawn fully opaque,
		that ALPHA uses as a mask. That is the case whenever the shape ends up composited with ALPHA,
		whether through its own blend mode, the group it is being rendered into, or the blend mode given
		to `BitmapData.draw`.
	**/
	@:noCompletion private function __isCompositedWithAlpha(displayObject:DisplayObject):Bool
	{
		return displayObject.__worldBlendMode == ALPHA || __groupBlendMode == ALPHA || __overrideBlendMode == ALPHA;
	}

	/**
		Whether an object under ALPHA needs a separate coverage mask, or whether its own pixels already
		show which area it covers.

		Flash's ALPHA only affects the area an object covers: the whole rectangle of a Bitmap,
		transparent pixels included, but only the fills of a shape. The rest of the object's bounding
		box keeps the backdrop. A single object without graphics, such as a Bitmap, that is not rotated
		or skewed covers exactly its bounding box, so it needs no mask. Anything with graphics, anything
		with children, and anything rotated or skewed does.
	**/
	@:noCompletion private function __alphaNeedsMask(displayObject:DisplayObject):Bool
	{
		if (displayObject.__graphics != null) return true;
		if (displayObject.__children != null && displayObject.__children.length > 0) return true;
		var transform = displayObject.__renderTransform;
		return transform.b != 0 || transform.c != 0;
	}

	/**
		Whether a blended object can be composited straight from pixels it already has, instead of first
		being rendered into a group of its own.

		That is true for a Bitmap, using its bitmapData, and for a Shape or an empty Sprite, using its
		rendered graphics, as long as it has no children, mask, scroll rectangle, opaque background,
		color transform or cache bitmap. Other objects with graphics, such as a TextField, draw
		themselves in their own way and always use a group. The cache bitmap is brought up to date
		first, as a normal draw would do, so that filters are taken into account.
	**/
	@:noCompletion private function __isBlendLeaf(displayObject:DisplayObject):Bool
	{
		var type = displayObject.__drawableType;
		if (type != BITMAP && type != SHAPE && type != SPRITE) return false;
		if (displayObject.__children != null && displayObject.__children.length > 0) return false;
		if (displayObject.__mask != null || displayObject.__scrollRect != null || displayObject.opaqueBackground != null) return false;
		if (!displayObject.__worldColorTransform.__isDefault(false)) return false;
		__updateCacheBitmap(displayObject, false);
		if (displayObject.__cacheBitmap != null) return false;
		return type == BITMAP || displayObject.__graphics != null;
	}

	@:noCompletion private function new()
	{
		super();

		__allowSmoothing = true;
		__pixelRatio = 1;
		__tempColorTransform = new ColorTransform();
		__worldAlpha = 1;
		__blendMode = NORMAL;
	}

	@:noCompletion private function __clear():Void {}

	@:noCompletion private function __getAlpha(value:Float):Float
	{
		return value * __worldAlpha;
	}

	@:noCompletion private function __getColorTransform(value:ColorTransform):ColorTransform
	{
		if (__worldColorTransform != null)
		{
			__tempColorTransform.__copyFrom(__worldColorTransform);
			__tempColorTransform.__combine(value);
			return __tempColorTransform;
		}
		else
		{
			return value;
		}
	}

	@:noCompletion private function __popMask():Void {}

	@:noCompletion private function __popMaskObject(object:DisplayObject, handleScrollRect:Bool = true):Void {}

	@:noCompletion private function __popMaskRect():Void {}

	@:noCompletion private function __pushMask(mask:DisplayObject):Void {}

	@:noCompletion private function __pushMaskObject(object:DisplayObject, handleScrollRect:Bool = true):Void {}

	@:noCompletion private function __pushMaskRect(rect:Rectangle, transform:Matrix):Void {}

	@:noCompletion private function __render(object:IBitmapDrawable):Void {}

	@:noCompletion private function __renderEvent(displayObject:DisplayObject):Void
	{
		var renderer = this;
		#if lime
		if (displayObject.__customRenderEvent != null && displayObject.__renderable)
		{
			displayObject.__customRenderEvent.allowSmoothing = renderer.__allowSmoothing;
			displayObject.__customRenderEvent.objectMatrix.copyFrom(displayObject.__renderTransform);
			displayObject.__customRenderEvent.objectColorTransform.__copyFrom(displayObject.__worldColorTransform);
			displayObject.__customRenderEvent.renderer = renderer;

			switch (renderer.__type)
			{
				case OPENGL:
					if (!renderer.__cleared) renderer.__clear();

					var renderer:OpenGLRenderer = cast renderer;
					renderer.setShader(displayObject.__worldShader);
					renderer.__context3D.__flushGL();

					displayObject.__customRenderEvent.type = RenderEvent.RENDER_OPENGL;

				case CAIRO:
					displayObject.__customRenderEvent.type = RenderEvent.RENDER_CAIRO;

				case DOM:
					if (displayObject.stage != null && displayObject.__worldVisible)
					{
						displayObject.__customRenderEvent.type = RenderEvent.RENDER_DOM;
					}
					else
					{
						displayObject.__customRenderEvent.type = RenderEvent.CLEAR_DOM;
					}

				case CANVAS:
					displayObject.__customRenderEvent.type = RenderEvent.RENDER_CANVAS;

				default:
					return;
			}

			renderer.__setBlendMode(displayObject.__worldBlendMode);
			renderer.__pushMaskObject(displayObject);

			displayObject.dispatchEvent(displayObject.__customRenderEvent);

			renderer.__popMaskObject(displayObject);

			if (renderer.__type == OPENGL)
			{
				var renderer:OpenGLRenderer = cast renderer;
				renderer.setViewport();
			}
		}
		#end
	}

	@:noCompletion private function __resize(width:Int, height:Int):Void {}

	/**
		Sets the blend mode on the render target. Nothing happens if the renderer already has that mode
		set, unless `force` is true. Use `force` when another renderer may have changed the target's
		state in the meantime, as happens when a cacheAsBitmap child renderer draws with the same
		context (see `__updateCacheBitmap`).
	**/
	@:noCompletion private function __setBlendMode(value:BlendMode, force:Bool = false):Void {}

	@:noCompletion private function __shouldCacheHardware(displayObject:DisplayObject, value:Null<Bool>):Null<Bool>
	{
		if (displayObject == null) return null;

		switch (displayObject.__drawableType)
		{
			case SPRITE, STAGE:
				if (value == true) return true;
				value = __shouldCacheHardware_DisplayObject(displayObject, value);
				if (value == true) return true;

				if (displayObject.__children != null)
				{
					for (child in displayObject.__children)
					{
						value = __shouldCacheHardware_DisplayObject(child, value);
						if (value == true) return true;
					}
				}

				return value;

			case TEXT_FIELD:
				return value == true ? true : false;

			case TILEMAP:
				return true;

			default:
				return __shouldCacheHardware_DisplayObject(displayObject, value);
		}
	}

	@:noCompletion private function __shouldCacheHardware_DisplayObject(displayObject:DisplayObject, value:Null<Bool>):Null<Bool>
	{
		if (value == true || displayObject.__filters != null) return true;

		if (value == false || (displayObject.__graphics != null && !Context3DGraphics.isCompatible(displayObject.__graphics)))
		{
			return false;
		}

		return null;
	}

	@:noCompletion private function __updateCacheBitmap(displayObject:DisplayObject, force:Bool):Bool
	{
		if (displayObject == null) return false;
		var renderer = this;

		switch (displayObject.__drawableType)
		{
			case BITMAP:
				var bitmap:Bitmap = cast displayObject;
				// TODO: Handle filters without an intermediate draw
				if (bitmap.__bitmapData == null
					|| (bitmap.__filters == null #if lime && renderer.__type == OPENGL #end && bitmap.__cacheBitmap == null)) return false;
				force = (bitmap.__bitmapData.image != null && bitmap.__bitmapData.image.version != bitmap.__imageVersion);

			case TEXT_FIELD:
				var textField:TextField = cast displayObject;
				if (textField.__filters == null #if lime && renderer.__type == OPENGL #end && textField.__cacheBitmap == null
					&& !textField.__domRender) return false;
				if (force) textField.__renderDirty = true;
				force = force || textField.__dirty;

			case TILEMAP:
				var tilemap:Tilemap = cast displayObject;
				if (tilemap.__filters == null #if lime && renderer.__type == OPENGL #end && tilemap.__cacheBitmap == null) return false;

			default:
		}

		#if lime
		if (displayObject.__isCacheBitmapRender) return false;
		#if openfl_disable_cacheasbitmap
		return false;
		#end

		var colorTransform = ColorTransform.__pool.get();
		colorTransform.__copyFrom(displayObject.__worldColorTransform);
		if (renderer.__worldColorTransform != null) colorTransform.__combine(renderer.__worldColorTransform);
		var updated = false;

		if (displayObject.cacheAsBitmap
			|| (renderer.__type != OPENGL
				&& !colorTransform.__isDefault(true) #if (openfl_legacy_scale9grid && openfl_force_gl_cacheasbitmap_for_scale9grid)
					|| (renderer.__type == OPENGL && displayObject.scale9Grid != null) #end))
		{
			var rect:Rectangle = null;

			var needRender = (displayObject.__cacheBitmap == null
				|| (displayObject.__renderDirty
					&& (force
						|| displayObject.__cacheBitmap != null
						|| (displayObject.__children != null && displayObject.__children.length > 0)))
				|| displayObject.opaqueBackground != displayObject.__cacheBitmapBackground);
			var softwareDirty = needRender
				|| (displayObject.__graphics != null && displayObject.__graphics.__softwareDirty)
				|| !displayObject.__cacheBitmapColorTransform.__equals(colorTransform, true);
			var hardwareDirty = needRender || (displayObject.__graphics != null && displayObject.__graphics.__hardwareDirty);

			var renderType = renderer.__type;

			if (softwareDirty || hardwareDirty)
			{
				#if !openfl_force_gl_cacheasbitmap
				if (renderType == OPENGL)
				{
					if (#if !openfl_disable_gl_cacheasbitmap __shouldCacheHardware(displayObject, null) == false #else true #end)
					{
						#if (js && html5)
						renderType = CANVAS;
						#else
						renderType = CAIRO;
						#end
					}
				}
				#end

				if (softwareDirty && (renderType == CANVAS || renderType == CAIRO)) needRender = true;
				if (hardwareDirty && renderType == OPENGL) needRender = true;
			}

			var updateTransform = (needRender || !displayObject.__cacheBitmap.__worldTransform.equals(displayObject.__worldTransform));
			var hasFilters = #if !openfl_disable_filters displayObject.__filters != null #else false #end;

			#if !openfl_enable_cacheasbitmap
			if (renderer.__type == DOM && !hasFilters)
			{
				return false;
			}
			#end

			if (hasFilters && !needRender)
			{
				var affineChanged:Bool = updateTransform
					&& __affineChanged(displayObject.__cacheBitmap.__worldTransform, displayObject.__worldTransform);

				for (filter in displayObject.__filters)
				{
					if (filter.__renderDirty)
					{
						needRender = true;
						break;
					}
					if (affineChanged && __isShaderFilter(filter))
					{
						displayObject.__cacheBitmapData = null;
						needRender = true;
						break;
					}
				}
			}

			if (displayObject.__cacheBitmapMatrix == null)
			{
				displayObject.__cacheBitmapMatrix = new Matrix();
			}

			var bitmapMatrix = (displayObject.__cacheAsBitmapMatrix != null ? displayObject.__cacheAsBitmapMatrix : displayObject.__renderTransform);

			if (!needRender
				&& (bitmapMatrix.a != displayObject.__cacheBitmapMatrix.a
					|| bitmapMatrix.b != displayObject.__cacheBitmapMatrix.b
					|| bitmapMatrix.c != displayObject.__cacheBitmapMatrix.c
					|| bitmapMatrix.d != displayObject.__cacheBitmapMatrix.d))
			{
				needRender = true;
			}

			if (!needRender
				&& renderer.__type != OPENGL
				&& displayObject.__cacheBitmapData != null
				&& displayObject.__cacheBitmapData.image != null
				&& displayObject.__cacheBitmapData.image.version < displayObject.__cacheBitmapData.__textureVersion)
			{
				needRender = true;
			}

			// Ensure that cached bitmap is updated after changes to scrollRect
			if (!needRender)
			{
				var current = displayObject;
				while (current != null)
				{
					if (current.scrollRect != null)
					{
						// TODO: do we need to update transform if scroll rects haven't changed?
						updateTransform = true;
						break;
					}
					current = current.parent;
				}
			}

			displayObject.__cacheBitmapMatrix.copyFrom(bitmapMatrix);
			displayObject.__cacheBitmapMatrix.tx = 0;
			displayObject.__cacheBitmapMatrix.ty = 0;

			// TODO: Handle dimensions better if object has a scrollRect?

			var bitmapWidth = 0, bitmapHeight = 0;
			var filterWidth = 0, filterHeight = 0;
			var offsetX = 0., offsetY = 0.;

			#if (openfl_disable_hdpi || openfl_disable_hdpi_cacheasbitmap)
			var pixelRatio = 1;
			#else
			var pixelRatio = __pixelRatio;
			#end

			if (updateTransform || needRender)
			{
				rect = Rectangle.__pool.get();

				displayObject.__getFilterBounds(rect, displayObject.__cacheBitmapMatrix);

				filterWidth = rect.width > 0 ? Math.ceil((rect.width + 1) * pixelRatio) : 0;
				filterHeight = rect.height > 0 ? Math.ceil((rect.height + 1) * pixelRatio) : 0;

				offsetX = rect.x > 0 ? Math.ceil(rect.x) : Math.floor(rect.x);
				offsetY = rect.y > 0 ? Math.ceil(rect.y) : Math.floor(rect.y);

				if (displayObject.__cacheBitmapData != null)
				{
					if (filterWidth > displayObject.__cacheBitmapData.width || filterHeight > displayObject.__cacheBitmapData.height)
					{
						bitmapWidth = Math.ceil(Math.max(filterWidth * 1.25, displayObject.__cacheBitmapData.width));
						bitmapHeight = Math.ceil(Math.max(filterHeight * 1.25, displayObject.__cacheBitmapData.height));
						needRender = true;
					}
					else
					{
						bitmapWidth = displayObject.__cacheBitmapData.width;
						bitmapHeight = displayObject.__cacheBitmapData.height;
					}
				}
				else
				{
					bitmapWidth = filterWidth;
					bitmapHeight = filterHeight;
				}
			}

			if (needRender)
			{
				updateTransform = true;
				displayObject.__cacheBitmapBackground = displayObject.opaqueBackground;

				if (filterWidth >= 0.5 && filterHeight >= 0.5)
				{
					var needsFill = (displayObject.opaqueBackground != null
						&& (bitmapWidth != filterWidth || bitmapHeight != filterHeight));
					var fillColor = displayObject.opaqueBackground != null ? (0xFF << 24) | displayObject.opaqueBackground : 0;
					var bitmapColor = needsFill ? 0 : fillColor;
					var allowFramebuffer = (renderer.__type == OPENGL);

					if (displayObject.__cacheBitmapData == null
						|| bitmapWidth > displayObject.__cacheBitmapData.width
						|| bitmapHeight > displayObject.__cacheBitmapData.height)
					{
						displayObject.__cacheBitmapData = new BitmapData(bitmapWidth, bitmapHeight, true, bitmapColor);

						if (displayObject.__cacheBitmap == null) displayObject.__cacheBitmap = new Bitmap();
						displayObject.__cacheBitmap.__bitmapData = displayObject.__cacheBitmapData;
						displayObject.__cacheBitmapRenderer = null;
					}
					else
					{
						displayObject.__cacheBitmapData.__fillRect(displayObject.__cacheBitmapData.rect, bitmapColor, allowFramebuffer);
					}

					if (needsFill)
					{
						rect.setTo(0, 0, filterWidth, filterHeight);
						displayObject.__cacheBitmapData.__fillRect(rect, fillColor, allowFramebuffer);
					}
				}
				else
				{
					ColorTransform.__pool.release(colorTransform);

					displayObject.__cacheBitmap = null;
					displayObject.__cacheBitmapData = null;
					displayObject.__cacheBitmapData2 = null;
					displayObject.__cacheBitmapData3 = null;
					displayObject.__cacheBitmapRenderer = null;

					if (displayObject.__drawableType == TEXT_FIELD)
					{
						var textField:TextField = cast displayObject;
						if (textField.__cacheBitmap != null)
						{
							textField.__cacheBitmap.__renderTransform.tx -= textField.__offsetX * pixelRatio;
							textField.__cacheBitmap.__renderTransform.ty -= textField.__offsetY * pixelRatio;
						}
					}

					return true;
				}
			}
			else
			{
				// Should we retain these longer?

				displayObject.__cacheBitmapData = displayObject.__cacheBitmap.bitmapData;
				displayObject.__cacheBitmapData2 = null;
				displayObject.__cacheBitmapData3 = null;
			}

			if (updateTransform || needRender)
			{
				displayObject.__cacheBitmap.__worldTransform.copyFrom(displayObject.__worldTransform);

				if (bitmapMatrix == displayObject.__renderTransform)
				{
					displayObject.__cacheBitmap.__renderTransform.identity();
					displayObject.__cacheBitmap.__renderTransform.scale(1 / pixelRatio, 1 / pixelRatio);
					displayObject.__cacheBitmap.__renderTransform.tx = displayObject.__renderTransform.tx + offsetX;
					displayObject.__cacheBitmap.__renderTransform.ty = displayObject.__renderTransform.ty + offsetY;
				}
				else
				{
					displayObject.__cacheBitmap.__renderTransform.copyFrom(displayObject.__cacheBitmapMatrix);
					displayObject.__cacheBitmap.__renderTransform.invert();
					displayObject.__cacheBitmap.__renderTransform.concat(displayObject.__renderTransform);
					displayObject.__cacheBitmap.__renderTransform.a *= 1 / pixelRatio;
					displayObject.__cacheBitmap.__renderTransform.d *= 1 / pixelRatio;
					displayObject.__cacheBitmap.__renderTransform.tx += offsetX;
					displayObject.__cacheBitmap.__renderTransform.ty += offsetY;
				}
			}

			displayObject.__cacheBitmap.smoothing = renderer.__allowSmoothing;
			displayObject.__cacheBitmap.__renderable = displayObject.__renderable;
			displayObject.__cacheBitmap.__worldAlpha = displayObject.__worldAlpha;
			displayObject.__cacheBitmap.__worldBlendMode = displayObject.__worldBlendMode;
			displayObject.__cacheBitmap.__worldShader = displayObject.__worldShader;
			// displayObject.__cacheBitmap.__scrollRect = displayObject.__scrollRect;
			// displayObject.__cacheBitmap.filters = displayObject.filters;

			// the cache bitmap should not take ownership of the mask, so take
			// advantage of the fact that clipping layers can be shared
			displayObject.__cacheBitmap.clippingLayer = displayObject.__mask;

			if (needRender)
			{
				#if lime
				if (displayObject.__cacheBitmapRenderer == null || renderType != displayObject.__cacheBitmapRenderer.__type)
				{
					if (renderType == OPENGL)
					{
						displayObject.__cacheBitmapRenderer = new OpenGLRenderer(cast(renderer, OpenGLRenderer).__context3D, displayObject.__cacheBitmapData);
					}
					else
					{
						if (displayObject.__cacheBitmapData.image == null)
						{
							var color = displayObject.opaqueBackground != null ? (0xFF << 24) | displayObject.opaqueBackground : 0;
							displayObject.__cacheBitmapData = new BitmapData(bitmapWidth, bitmapHeight, true, color);
							displayObject.__cacheBitmap.__bitmapData = displayObject.__cacheBitmapData;
						}

						#if (js && html5)
						ImageCanvasUtil.convertToCanvas(displayObject.__cacheBitmapData.image);
						displayObject.__cacheBitmapRenderer = new CanvasRenderer(displayObject.__cacheBitmapData.image.buffer.__srcContext);
						#else
						displayObject.__cacheBitmapRenderer = new CairoRenderer(new Cairo(displayObject.__cacheBitmapData.getSurface()));
						// the bitmap drawn into, for the composites that work on views of its bytes
						cast(displayObject.__cacheBitmapRenderer, CairoRenderer).__targetBitmap = displayObject.__cacheBitmapData;
						#end
					}

					displayObject.__cacheBitmapRenderer.__worldTransform = new Matrix();
					displayObject.__cacheBitmapRenderer.__worldColorTransform = new ColorTransform();
				}
				#else
				return false;
				#end

				if (displayObject.__cacheBitmapColorTransform == null) displayObject.__cacheBitmapColorTransform = new ColorTransform();

				displayObject.__cacheBitmapRenderer.__stage = displayObject.stage;
				// the scratch bitmaps of the groups are kept per layer depth and shared by every renderer:
				// the cache is drawn while this renderer's groups are open, so its own start above them
				displayObject.__cacheBitmapRenderer.__layerDepth = __layerDepth;

				displayObject.__cacheBitmapRenderer.__allowSmoothing = renderer.__allowSmoothing;
				// another renderer has drawn with this context since, so the mode is applied whatever
				// this renderer believes it holds
				displayObject.__cacheBitmapRenderer.__setBlendMode(NORMAL, true);
				displayObject.__cacheBitmapRenderer.__worldAlpha = 1 / displayObject.__worldAlpha;

				displayObject.__cacheBitmapRenderer.__worldTransform.copyFrom(displayObject.__renderTransform);
				displayObject.__cacheBitmapRenderer.__worldTransform.invert();
				displayObject.__cacheBitmapRenderer.__worldTransform.concat(displayObject.__cacheBitmapMatrix);
				displayObject.__cacheBitmapRenderer.__worldTransform.tx -= offsetX;
				displayObject.__cacheBitmapRenderer.__worldTransform.ty -= offsetY;
				displayObject.__cacheBitmapRenderer.__worldTransform.scale(pixelRatio, pixelRatio);

				displayObject.__cacheBitmapRenderer.__pixelRatio = pixelRatio;

				displayObject.__cacheBitmapRenderer.__worldColorTransform.__copyFrom(colorTransform);
				displayObject.__cacheBitmapRenderer.__worldColorTransform.__invert();

				displayObject.__isCacheBitmapRender = true;

				if (displayObject.__cacheBitmapRenderer.__type == OPENGL)
				{
					var parentRenderer:OpenGLRenderer = cast renderer;
					var childRenderer:OpenGLRenderer = cast displayObject.__cacheBitmapRenderer;

					var context = childRenderer.__context3D;

					var cacheRTT = context.__state.renderToTexture;
					var cacheRTTDepthStencil = context.__state.renderToTextureDepthStencil;
					var cacheRTTAntiAlias = context.__state.renderToTextureAntiAlias;
					var cacheRTTSurfaceSelector = context.__state.renderToTextureSurfaceSelector;

					// var cacheFramebuffer = context.__contextState.__currentGLFramebuffer;

					var cacheBlendMode = parentRenderer.__blendMode;
					parentRenderer.__suspendClipAndMask();
					childRenderer.__copyShader(parentRenderer);
					// childRenderer.__copyState (parentRenderer);

					displayObject.__cacheBitmapData.__setUVRect(context, 0, 0, filterWidth, filterHeight);
					childRenderer.__setRenderTarget(displayObject.__cacheBitmapData);
					if (displayObject.__cacheBitmapData.image != null)
						displayObject.__cacheBitmapData.__textureVersion = displayObject.__cacheBitmapData.image.version
						+ 1;

					displayObject.__cacheBitmapData.__drawGL(displayObject, childRenderer);

					if (hasFilters)
					{
						var needSecondBitmapData = true;
						var needCopyOfOriginal = false;

						for (filter in displayObject.__filters)
						{
							// if (filter.__needSecondBitmapData) {
							// 	needSecondBitmapData = true;
							// }
							if (filter.__preserveObject)
							{
								needCopyOfOriginal = true;
							}
						}

						var bitmap = displayObject.__cacheBitmapData;
						var bitmap2:BitmapData = null;
						var bitmap3:BitmapData = null;

						// if (needSecondBitmapData) {
						if (displayObject.__cacheBitmapData2 == null
							|| bitmapWidth > displayObject.__cacheBitmapData2.width
							|| bitmapHeight > displayObject.__cacheBitmapData2.height)
						{
							displayObject.__cacheBitmapData2 = new BitmapData(bitmapWidth, bitmapHeight, true, 0);
						}
						else
						{
							displayObject.__cacheBitmapData2.fillRect(displayObject.__cacheBitmapData2.rect, 0);
							if (displayObject.__cacheBitmapData2.image != null)
							{
								displayObject.__cacheBitmapData2.__textureVersion = displayObject.__cacheBitmapData2.image.version + 1;
							}
						}
						displayObject.__cacheBitmapData2.__setUVRect(context, 0, 0, filterWidth, filterHeight);
						bitmap2 = displayObject.__cacheBitmapData2;
						// } else {
						// 	bitmap2 = bitmapData;
						// }

						if (needCopyOfOriginal)
						{
							if (displayObject.__cacheBitmapData3 == null
								|| bitmapWidth > displayObject.__cacheBitmapData3.width
								|| bitmapHeight > displayObject.__cacheBitmapData3.height)
							{
								displayObject.__cacheBitmapData3 = new BitmapData(bitmapWidth, bitmapHeight, true, 0);
							}
							else
							{
								displayObject.__cacheBitmapData3.fillRect(displayObject.__cacheBitmapData3.rect, 0);
								if (displayObject.__cacheBitmapData3.image != null)
								{
									displayObject.__cacheBitmapData3.__textureVersion = displayObject.__cacheBitmapData3.image.version + 1;
								}
							}
							displayObject.__cacheBitmapData3.__setUVRect(context, 0, 0, filterWidth, filterHeight);
							bitmap3 = displayObject.__cacheBitmapData3;
						}

						childRenderer.__setBlendMode(NORMAL, true);
						childRenderer.__worldAlpha = 1;
						childRenderer.__worldTransform.identity();
						childRenderer.__worldColorTransform.__identity();

						// var sourceRect = bitmap.rect;
						// if (__tempPoint == null) __tempPoint = new Point ();
						// var destPoint = __tempPoint;
						var shader:Shader;
						var cacheBitmap:BitmapData;

						for (filter in displayObject.__filters)
						{
							if (filter.__preserveObject)
							{
								childRenderer.__setRenderTarget(bitmap3);
								childRenderer.__renderFilterPass(bitmap, childRenderer.__defaultDisplayShader, filter.__smooth);
							}

							for (i in 0...filter.__numShaderPasses)
							{
								shader = filter.__initShader(childRenderer, i, filter.__preserveObject ? bitmap3 : null);
								childRenderer.__setBlendMode(filter.__shaderBlendMode);
								childRenderer.__setRenderTarget(bitmap2);
								childRenderer.__renderFilterPass(bitmap, shader, filter.__smooth);

								cacheBitmap = bitmap;
								bitmap = bitmap2;
								bitmap2 = cacheBitmap;
							}

							filter.__renderDirty = false;
						}

						displayObject.__cacheBitmap.__bitmapData = bitmap;
					}

					// the child renderer left its own blend factors in the context
					parentRenderer.__setBlendMode(cacheBlendMode, true);
					parentRenderer.__copyShader(childRenderer);

					if (cacheRTT != null)
					{
						context.setRenderToTexture(cacheRTT, cacheRTTDepthStencil, cacheRTTAntiAlias, cacheRTTSurfaceSelector);
					}
					else
					{
						context.setRenderToBackBuffer();
					}

					// context.__bindGLFramebuffer (cacheFramebuffer);

					// parentRenderer.__restoreState (childRenderer);
					parentRenderer.__resumeClipAndMask(childRenderer);
					parentRenderer.setViewport();

					displayObject.__cacheBitmapColorTransform.__copyFrom(colorTransform);
				}
				else
				{
					#if (js && html5)
					displayObject.__cacheBitmapData.__drawCanvas(displayObject, cast displayObject.__cacheBitmapRenderer);
					#else
					displayObject.__cacheBitmapData.__drawCairo(displayObject, cast displayObject.__cacheBitmapRenderer);
					#end

					if (hasFilters)
					{
						var needSecondBitmapData = false;
						var needCopyOfOriginal = false;

						for (filter in displayObject.__filters)
						{
							if (filter.__needSecondBitmapData)
							{
								needSecondBitmapData = true;
							}
							if (filter.__preserveObject)
							{
								needCopyOfOriginal = true;
							}
						}

						var bitmap = displayObject.__cacheBitmapData;
						var bitmap2:BitmapData = null;
						var bitmap3:BitmapData = null;

						if (needSecondBitmapData)
						{
							if (displayObject.__cacheBitmapData2 == null
								|| displayObject.__cacheBitmapData2.image == null
								|| bitmapWidth > displayObject.__cacheBitmapData2.width
								|| bitmapHeight > displayObject.__cacheBitmapData2.height)
							{
								displayObject.__cacheBitmapData2 = new BitmapData(bitmapWidth, bitmapHeight, true, 0);
							}
							else
							{
								displayObject.__cacheBitmapData2.fillRect(displayObject.__cacheBitmapData2.rect, 0);
							}
							bitmap2 = displayObject.__cacheBitmapData2;
						}
						else
						{
							bitmap2 = bitmap;
						}

						if (needCopyOfOriginal)
						{
							if (displayObject.__cacheBitmapData3 == null
								|| displayObject.__cacheBitmapData3.image == null
								|| bitmapWidth > displayObject.__cacheBitmapData3.width
								|| bitmapHeight > displayObject.__cacheBitmapData3.height)
							{
								displayObject.__cacheBitmapData3 = new BitmapData(bitmapWidth, bitmapHeight, true, 0);
							}
							else
							{
								displayObject.__cacheBitmapData3.fillRect(displayObject.__cacheBitmapData3.rect, 0);
							}
							bitmap3 = displayObject.__cacheBitmapData3;
						}

						if (displayObject.__tempPoint == null) displayObject.__tempPoint = new Point();
						var destPoint = displayObject.__tempPoint;
						var cacheBitmap:BitmapData;
						var lastBitmap:BitmapData;

						for (filter in displayObject.__filters)
						{
							if (filter.__preserveObject)
							{
								bitmap3.copyPixels(bitmap, bitmap.rect, destPoint);
							}

							lastBitmap = filter.__applyFilter(bitmap2, bitmap, bitmap.rect, destPoint);

							if (filter.__preserveObject)
							{
								lastBitmap.draw(bitmap3, null,
									displayObject.__objectTransform != null ? displayObject.__objectTransform.__colorTransform : null);
							}
							filter.__renderDirty = false;

							if (needSecondBitmapData && lastBitmap == bitmap2)
							{
								cacheBitmap = bitmap;
								bitmap = bitmap2;
								bitmap2 = cacheBitmap;
							}
						}

						if (displayObject.__cacheBitmapData != bitmap)
						{
							// TODO: Fix issue with swapping __cacheBitmap.__bitmapData
							// __cacheBitmapData.copyPixels (bitmap, bitmap.rect, destPoint);

							// Adding __cacheBitmapRenderer = null; makes this work
							cacheBitmap = displayObject.__cacheBitmapData;
							displayObject.__cacheBitmapData = bitmap;
							displayObject.__cacheBitmapData2 = cacheBitmap;
							displayObject.__cacheBitmap.__bitmapData = displayObject.__cacheBitmapData;
							displayObject.__cacheBitmapRenderer = null;
						}

						displayObject.__cacheBitmap.__imageVersion = displayObject.__cacheBitmapData.__textureVersion;
					}

					displayObject.__cacheBitmapColorTransform.__copyFrom(colorTransform);

					if (!displayObject.__cacheBitmapColorTransform.__isDefault(true))
					{
						displayObject.__cacheBitmapColorTransform.alphaMultiplier = 1;
						displayObject.__cacheBitmapData.colorTransform(displayObject.__cacheBitmapData.rect, displayObject.__cacheBitmapColorTransform);
					}
				}

				displayObject.__isCacheBitmapRender = false;
			}

			if (updateTransform || needRender)
			{
				Rectangle.__pool.release(rect);
			}

			updated = updateTransform;
		}
		else if (displayObject.__cacheBitmap != null)
		{
			if (renderer.__type == DOM)
			{
				var domRenderer:DOMRenderer = cast renderer;
				domRenderer.__renderDrawableClear(displayObject.__cacheBitmap);
			}

			displayObject.__cacheBitmap = null;
			displayObject.__cacheBitmapData = null;
			displayObject.__cacheBitmapData2 = null;
			displayObject.__cacheBitmapData3 = null;
			displayObject.__cacheBitmapColorTransform = null;
			displayObject.__cacheBitmapRenderer = null;

			updated = true;
		}

		ColorTransform.__pool.release(colorTransform);

		if (updated && displayObject.__drawableType == TEXT_FIELD)
		{
			var textField:TextField = cast displayObject;
			if (textField.__cacheBitmap != null)
			{
				textField.__cacheBitmap.__renderTransform.tx -= textField.__offsetX;
				textField.__cacheBitmap.__renderTransform.ty -= textField.__offsetY;
			}
		}

		return updated;
		#else
		return false;
		#end
	}

	@:noCompletion private inline function __affineChanged(a:Matrix, b:Matrix, eps = 1e-4):Bool
	{
		return (Math.abs(a.a - b.a) > eps) || (Math.abs(a.b - b.b) > eps) || (Math.abs(a.c - b.c) > eps) || (Math.abs(a.d - b.d) > eps);
	}

	#if (haxe_ver >= 4.2)
	@:noCompletion private inline function __isShaderFilter(f:Dynamic):Bool
		return Std.isOfType(f, ShaderFilter);
	#else
	@:noCompletion private inline function __isShaderFilter(f:Dynamic):Bool
		return Std.is(f, ShaderFilter);
	#end
}
#else
typedef DisplayObjectRenderer = Dynamic;
#end
