package openfl.display;

#if !flash
import openfl.display._internal.Context3DGraphics;
import openfl.display.Bitmap;
import openfl.display.DisplayObject;
import openfl.display.Tilemap;
import openfl.events.EventDispatcher;
import openfl.events.RenderEvent;
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
	@:noCompletion private var __roundPixels:Bool;
	@:noCompletion private var __stage:Stage;
	@:noCompletion private var __tempColorTransform:ColorTransform;
	@:noCompletion private var __transparent:Bool;
	@SuppressWarnings("checkstyle:Dynamic") @:noCompletion private var __type:#if lime RenderContextType #else Dynamic #end;
	@:noCompletion private var __worldAlpha:Float;
	@:noCompletion private var __worldColorTransform:ColorTransform;
	@:noCompletion private var __worldTransform:Matrix;

	@:noCompletion private function new()
	{
		super();

		__allowSmoothing = true;
		__tempColorTransform = new ColorTransform();
		__worldAlpha = 1;
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

	@:noCompletion private function __setBlendMode(value:BlendMode):Void {}

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

		if (displayObject.cacheAsBitmap || (renderer.__type != OPENGL && !colorTransform.__isDefault(true)))
		{
			var rect = null;

			var needRender = (displayObject.__cacheBitmap == null
				|| (displayObject.__renderDirty && (force || (displayObject.__children != null && displayObject.__children.length > 0)))
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

			if (hasFilters && !needRender)
			{
				for (filter in displayObject.__filters)
				{
					if (filter.__renderDirty)
					{
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

			displayObject.__cacheBitmapMatrix.copyFrom(bitmapMatrix);
			displayObject.__cacheBitmapMatrix.tx = 0;
			displayObject.__cacheBitmapMatrix.ty = 0;

			// TODO: Handle dimensions better if object has a scrollRect?

			var bitmapWidth = 0, bitmapHeight = 0;
			var filterWidth = 0, filterHeight = 0;
			var offsetX = 0., offsetY = 0.;

			if (updateTransform || needRender)
			{
				rect = Rectangle.__pool.get();

				displayObject.__getFilterBounds(rect, displayObject.__cacheBitmapMatrix);

				filterWidth = Math.ceil(rect.width);
				filterHeight = Math.ceil(rect.height);

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
							textField.__cacheBitmap.__renderTransform.tx -= textField.__offsetX;
							textField.__cacheBitmap.__renderTransform.ty -= textField.__offsetY;
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
					displayObject.__cacheBitmap.__renderTransform.tx = displayObject.__renderTransform.tx + offsetX;
					displayObject.__cacheBitmap.__renderTransform.ty = displayObject.__renderTransform.ty + offsetY;
				}
				else
				{
					displayObject.__cacheBitmap.__renderTransform.copyFrom(displayObject.__cacheBitmapMatrix);
					displayObject.__cacheBitmap.__renderTransform.invert();
					displayObject.__cacheBitmap.__renderTransform.concat(displayObject.__renderTransform);
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
			displayObject.__cacheBitmap.mask = displayObject.__mask;

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

				displayObject.__cacheBitmapRenderer.__allowSmoothing = renderer.__allowSmoothing;
				displayObject.__cacheBitmapRenderer.__setBlendMode(NORMAL);
				displayObject.__cacheBitmapRenderer.__worldAlpha = 1 / displayObject.__worldAlpha;

				displayObject.__cacheBitmapRenderer.__worldTransform.copyFrom(displayObject.__renderTransform);
				displayObject.__cacheBitmapRenderer.__worldTransform.invert();
				displayObject.__cacheBitmapRenderer.__worldTransform.concat(displayObject.__cacheBitmapMatrix);
				displayObject.__cacheBitmapRenderer.__worldTransform.tx -= offsetX;
				displayObject.__cacheBitmapRenderer.__worldTransform.ty -= offsetY;

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
						var bitmap2 = null;
						var bitmap3 = null;

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

						childRenderer.__setBlendMode(NORMAL);
						childRenderer.__worldAlpha = 1;
						childRenderer.__worldTransform.identity();
						childRenderer.__worldColorTransform.__identity();

						// var sourceRect = bitmap.rect;
						// if (__tempPoint == null) __tempPoint = new Point ();
						// var destPoint = __tempPoint;
						var shader, cacheBitmap;

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

					parentRenderer.__blendMode = NORMAL;
					parentRenderer.__setBlendMode(cacheBlendMode);
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
						var bitmap2 = null;
						var bitmap3 = null;

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
						var cacheBitmap, lastBitmap;

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
}
#else
typedef DisplayObjectRenderer = Dynamic;
#end
