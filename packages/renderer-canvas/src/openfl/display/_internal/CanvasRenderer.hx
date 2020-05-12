package openfl.display._internal;

#if openfl_html5
import openfl.text._internal.HTMLParser;
import openfl.display.Bitmap;
import openfl.display.BitmapData;
import openfl.display.BlendMode;
import openfl.display.CanvasRenderer as CanvasRendererAPI;
import openfl.display.DisplayObject;
import openfl.display.DisplayObjectContainer;
import openfl.display.DOMRenderer;
import openfl.display.IBitmapDrawable;
import openfl.display.SimpleButton;
import openfl.display.Tilemap;
import openfl.events.RenderEvent;
import openfl.geom.Point;
import openfl.media.Video;
import openfl.text.TextField;
import openfl.text.TextFieldType;
import openfl.geom.ColorTransform;
import openfl.geom.Matrix;
import openfl.geom._Matrix;
import openfl.geom.Rectangle;
import openfl.geom._Rectangle;
#if lime
import lime.graphics.Canvas2DRenderContext;
#else
import openfl._internal.backend.lime_standalone.Canvas2DRenderContext;
#end

#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
@:access(lime.graphics.ImageBuffer)
@:access(openfl._internal.backend.lime_standalone.ImageBuffer)
@:access(openfl.display.BitmapData)
@:access(openfl.display.DisplayObject)
@:access(openfl.display.DOMRenderer)
@:access(openfl.display.Graphics)
@:access(openfl.display.IBitmapDrawable)
@:access(openfl.display.Stage)
@:access(openfl.display.Stage3D)
@:access(openfl.events.RenderEvent)
@:access(openfl.filters.BitmapFilter)
@:access(openfl.geom.ColorTransform)
@:access(openfl.geom.Matrix)
@:access(openfl.geom.Rectangle)
@:allow(openfl.display._internal)
@:allow(openfl.display)
@SuppressWarnings("checkstyle:FieldDocComment")
class CanvasRenderer extends CanvasRendererAPI
{
	public var __colorTransform:ColorTransform;
	public var __domRenderer:DOMRenderer;
	public var __transform:Matrix;

	public function new(context:Canvas2DRenderContext)
	{
		super(context);

		__colorTransform = new ColorTransform();
		__transform = new Matrix();

		__type = CANVAS;
	}

	public override function applySmoothing(context:Canvas2DRenderContext, value:Bool):Void
	{
		context.imageSmoothingEnabled = value;
	}

	public override function setTransform(transform:Matrix, context:Canvas2DRenderContext = null):Void
	{
		if (context == null)
		{
			context = this.context;
		}
		else if (this.context == context && __worldTransform != null)
		{
			__transform.copyFrom(transform);
			__transform.concat(__worldTransform);
			transform = __transform;
		}

		if (__roundPixels)
		{
			context.setTransform(transform.a, transform.b, transform.c, transform.d, Std.int(transform.tx), Std.int(transform.ty));
		}
		else
		{
			context.setTransform(transform.a, transform.b, transform.c, transform.d, transform.tx, transform.ty);
		}
	}

	public override function __clear():Void
	{
		if (__stage != null)
		{
			var cacheBlendMode = __blendMode;
			__blendMode = null;
			__setBlendMode(NORMAL);

			context.setTransform(1, 0, 0, 1, 0, 0);
			context.globalAlpha = 1;

			if (!__stage._.__transparent && __stage._.__clearBeforeRender)
			{
				context.fillStyle = __stage._.__colorString;
				context.fillRect(0, 0, __stage.stageWidth * __stage._.__contentsScaleFactor, __stage.stageHeight * __stage._.__contentsScaleFactor);
			}
			else if (__stage._.__transparent && __stage._.__clearBeforeRender)
			{
				context.clearRect(0, 0, __stage.stageWidth * __stage._.__contentsScaleFactor, __stage.stageHeight * __stage._.__contentsScaleFactor);
			}

			__setBlendMode(cacheBlendMode);
		}
	}

	public override function __drawBitmapData(bitmapData:BitmapData, source:IBitmapDrawable, clipRect:Rectangle):Void
	{
		var clipMatrix = null;

		if (clipRect != null)
		{
			clipMatrix = _Matrix.__pool.get();
			clipMatrix.copyFrom(__worldTransform);
			clipMatrix.invert();
			__pushMaskRect(clipRect, clipMatrix);
		}

		var context = bitmapData._.__getCanvasContext(true);

		if (!__allowSmoothing) applySmoothing(context, false);

		__render(source);

		if (!__allowSmoothing) applySmoothing(context, true);

		context.setTransform(1, 0, 0, 1, 0, 0);
		// buffer._.__srcImageData = null;
		// buffer.data = null;

		bitmapData._.__setDirty();

		if (clipRect != null)
		{
			__popMaskRect();
			_Matrix.__pool.release(clipMatrix);
		}
	}

	public function __getAlpha(value:Float):Float
	{
		return value * __worldAlpha;
	}

	public function __getColorTransform(value:ColorTransform):ColorTransform
	{
		if (__worldColorTransform != null)
		{
			__colorTransform._.__copyFrom(__worldColorTransform);
			__colorTransform._.__combine(value);
			return __colorTransform;
		}
		else
		{
			return value;
		}
	}

	public function __popMask():Void
	{
		context.restore();
	}

	public function __popMaskObject(object:DisplayObject, handleScrollRect:Bool = true):Void
	{
		if (!object._.__renderData.isCacheBitmapRender && object._.__mask != null)
		{
			__popMask();
		}

		if (handleScrollRect && object._.__scrollRect != null)
		{
			__popMaskRect();
		}
	}

	public function __popMaskRect():Void
	{
		context.restore();
	}

	public function __pushMask(mask:DisplayObject):Void
	{
		context.save();

		setTransform(mask._.__renderTransform, context);

		context.beginPath();
		__renderMask(mask);
		context.closePath();

		context.clip();
	}

	public function __pushMaskObject(object:DisplayObject, handleScrollRect:Bool = true):Void
	{
		if (handleScrollRect && object._.__scrollRect != null)
		{
			__pushMaskRect(object._.__scrollRect, object._.__renderTransform);
		}

		if (!object._.__renderData.isCacheBitmapRender && object._.__mask != null)
		{
			__pushMask(object._.__mask);
		}
	}

	public function __pushMaskRect(rect:Rectangle, transform:Matrix):Void
	{
		context.save();

		setTransform(transform, context);

		context.beginPath();
		context.rect(rect.x, rect.y, rect.width, rect.height);
		context.clip();
	}

	public override function __render(object:IBitmapDrawable):Void
	{
		if (object != null)
		{
			if (object._.__type != null)
			{
				__renderDisplayObject(cast object);
			}
			else
			{
				__renderBitmapData(cast object);
			}
		}
	}

	public function __renderBitmap(bitmap:Bitmap):Void
	{
		__updateCacheBitmap(bitmap, /*!__worldColorTransform._.__isDefault ()*/ false);

		if (bitmap._.__bitmapData != null && bitmap._.__bitmapData._.__getCanvas() != null)
		{
			bitmap._.__imageVersion = bitmap._.__bitmapData._.__getVersion();
		}

		if (bitmap._.__renderData.cacheBitmap != null && !bitmap._.__renderData.isCacheBitmapRender)
		{
			CanvasBitmap.render(bitmap._.__renderData.cacheBitmap, this);
		}
		else
		{
			CanvasDisplayObject.render(bitmap, this);
			CanvasBitmap.render(bitmap, this);
		}
	}

	public function __renderBitmapData(bitmapData:BitmapData):Void
	{
		if (!bitmapData.readable) return;

		context.globalAlpha = 1;

		setTransform(bitmapData._.__renderTransform, context);

		context.drawImage(bitmapData._.__getElement(), 0, 0, bitmapData.width, bitmapData.height);
	}

	public function __renderDisplayObject(object:DisplayObject):Void
	{
		if (object != null && object._.__type != null)
		{
			switch (object._.__type)
			{
				case BITMAP:
					__renderBitmap(cast object);
				case DISPLAY_OBJECT_CONTAINER, MOVIE_CLIP:
					__renderDisplayObjectContainer(cast object);
				case DISPLAY_OBJECT, SHAPE:
					__renderShape(cast object);
				case SIMPLE_BUTTON:
					__renderSimpleButton(cast object);
				case TEXTFIELD:
					__renderTextField(cast object);
				case TILEMAP:
					__renderTilemap(cast object);
				case VIDEO:
					__renderVideo(cast object);
				default:
			}

			if (object._.__customRenderEvent != null)
			{
				var event = object._.__customRenderEvent;
				event.allowSmoothing = __allowSmoothing;
				event.objectMatrix.copyFrom(object._.__renderTransform);
				event.objectColorTransform._.__copyFrom(object._.__worldColorTransform);
				event.renderer = this;
				event.type = RenderEvent.RENDER_CANVAS;

				__setBlendMode(object._.__worldBlendMode);
				__pushMaskObject(object);

				object.dispatchEvent(event);

				__popMaskObject(object);
			}
		}
	}

	public function __renderDisplayObjectContainer(container:DisplayObjectContainer):Void
	{
		if (__domRenderer == null) container._.__cleanupRemovedChildren();

		if (!container._.__renderable
			|| container._.__worldAlpha <= 0
			|| (container.mask != null && (container.mask.width <= 0 || container.mask.height <= 0))) return;

		__updateCacheBitmap(container, /*!__worldColorTransform._.__isDefault ()*/ false);

		if (container._.__renderData.cacheBitmap != null && !container._.__renderData.isCacheBitmapRender)
		{
			CanvasBitmap.render(container._.__renderData.cacheBitmap, this);
		}
		else
		{
			CanvasDisplayObject.render(container, this);
		}

		if (container._.__renderData.cacheBitmap != null && !container._.__renderData.isCacheBitmapRender) return;

		__pushMaskObject(container);

		var child = container._.__firstChild;
		if (__stage != null)
		{
			while (child != null)
			{
				__renderDisplayObject(child);
				child._.__renderDirty = false;
				child = child._.__nextSibling;
			}

			container._.__renderDirty = false;
		}
		else
		{
			while (child != null)
			{
				__renderDisplayObject(child);
				child = child._.__nextSibling;
			}
		}

		__popMaskObject(container);
	}

	public function __renderMask(mask:DisplayObject):Void
	{
		if (mask != null)
		{
			switch (mask._.__type)
			{
				case BITMAP:
					context.rect(0, 0, mask.width, mask.height);

				case DISPLAY_OBJECT_CONTAINER, MOVIE_CLIP:
					var container:DisplayObjectContainer = cast mask;
					if (__domRenderer == null) container._.__cleanupRemovedChildren();

					if (container._.__graphics != null)
					{
						CanvasGraphics.renderMask(container._.__graphics, this);
					}

					var child = container._.__firstChild;
					while (child != null)
					{
						__renderMask(child);
						child = child._.__nextSibling;
					}

				case DOM_ELEMENT:

				case SIMPLE_BUTTON:
					var button:SimpleButton = cast mask;
					__renderMask(button._.__currentState);

				default:
					if (mask._.__graphics != null)
					{
						CanvasGraphics.renderMask(mask._.__graphics, this);
					}
			}
		}
	}

	public function __renderShape(shape:DisplayObject):Void
	{
		if (shape.mask == null || (shape.mask.width > 0 && shape.mask.height > 0))
		{
			__updateCacheBitmap(shape, /*!__worldColorTransform._.__isDefault ()*/ false);

			if (shape._.__renderData.cacheBitmap != null && !shape._.__renderData.isCacheBitmapRender)
			{
				CanvasBitmap.render(shape._.__renderData.cacheBitmap, this);
			}
			else
			{
				CanvasDisplayObject.render(shape, this);
			}
		}
	}

	public function __renderSimpleButton(button:SimpleButton):Void
	{
		if (!button._.__renderable || button._.__worldAlpha <= 0 || button._.__currentState == null) return;

		__pushMaskObject(button);
		__renderDisplayObject(button._.__currentState);
		__popMaskObject(button);
	}

	public function __renderTextField(textField:TextField):Void
	{
		#if openfl_html5
		// TODO: Better DOM workaround on cacheAsBitmap

		if (__domRenderer != null && !textField._.__renderedOnCanvasWhileOnDOM)
		{
			textField._.__renderedOnCanvasWhileOnDOM = true;

			if (textField.type == TextFieldType.INPUT)
			{
				textField.replaceText(0, textField._.__text.length, textField._.__text);
			}

			if (textField._.__isHTML)
			{
				textField._.__updateText(HTMLParser.parse(textField._.__text, textField._.__textFormat, textField._.__textEngine.textFormatRanges));
			}

			textField._.__dirty = true;
			textField._.__layoutDirty = true;
			textField._.__setRenderDirty();
		}

		if (textField.mask == null || (textField.mask.width > 0 && textField.mask.height > 0))
		{
			__updateCacheBitmap(textField, textField._.__dirty);

			if (textField._.__renderData.cacheBitmap != null && !textField._.__renderData.isCacheBitmapRender)
			{
				CanvasBitmap.render(textField._.__renderData.cacheBitmap, this);
			}
			else
			{
				CanvasTextField.render(textField, this, textField._.__worldTransform);

				var smoothingEnabled = false;

				if (textField._.__textEngine.antiAliasType == ADVANCED && textField._.__textEngine.gridFitType == PIXEL)
				{
					smoothingEnabled = context.imageSmoothingEnabled;

					if (smoothingEnabled)
					{
						context.imageSmoothingEnabled = false;
					}
				}

				CanvasDisplayObject.render(textField, this);

				if (smoothingEnabled)
				{
					context.imageSmoothingEnabled = true;
				}
			}
		}
		#end
	}

	public function __renderTilemap(tilemap:Tilemap):Void
	{
		__updateCacheBitmap(tilemap, /*!__worldColorTransform._.__isDefault ()*/ false);

		if (tilemap._.__renderData.cacheBitmap != null && !tilemap._.__renderData.isCacheBitmapRender)
		{
			CanvasBitmap.render(tilemap._.__renderData.cacheBitmap, this);
		}
		else
		{
			CanvasDisplayObject.render(tilemap, this);
			CanvasTilemap.render(tilemap, this);
		}
	}

	public function __renderVideo(video:Video):Void
	{
		CanvasVideo.render(video, this);
	}

	public function __setBlendMode(value:BlendMode):Void
	{
		if (__overrideBlendMode != null) value = __overrideBlendMode;
		if (__blendMode == value) return;

		__blendMode = value;
		__setBlendModeContext(context, value);
	}

	public function __setBlendModeContext(context:Canvas2DRenderContext, value:BlendMode):Void
	{
		switch (value)
		{
			case ADD:
				context.globalCompositeOperation = "lighter";

			// case ALPHA:

			// 	context.globalCompositeOperation = "";

			case DARKEN:
				context.globalCompositeOperation = "darken";

			case DIFFERENCE:
				context.globalCompositeOperation = "difference";

			// case ERASE:

			// context.globalCompositeOperation = "";

			case HARDLIGHT:
				context.globalCompositeOperation = "hard-light";

			// case INVERT:

			// context.globalCompositeOperation = "";

			// case LAYER:

			// 	context.globalCompositeOperation = "source-over";

			case LIGHTEN:
				context.globalCompositeOperation = "lighten";

			case MULTIPLY:
				context.globalCompositeOperation = "multiply";

			case OVERLAY:
				context.globalCompositeOperation = "overlay";

			case SCREEN:
				context.globalCompositeOperation = "screen";

			// case SHADER:

			// context.globalCompositeOperation = "";

			// case SUBTRACT:

			// context.globalCompositeOperation = "";

			default:
				context.globalCompositeOperation = "source-over";
		}
	}

	public function __updateCacheBitmap(object:DisplayObject, force:Bool):Bool
	{
		#if openfl_disable_cacheasbitmap
		return false;
		#end

		if (object._.__renderData.isCacheBitmapRender) return false;
		var updated = false;

		if (object.cacheAsBitmap
			|| !object._.__worldColorTransform._.__isDefault(true)
			|| (__worldColorTransform != null && !__worldColorTransform._.__isDefault(true)))
		{
			if (object._.__renderData.cacheBitmapMatrix == null)
			{
				object._.__renderData.cacheBitmapMatrix = new Matrix();
			}

			var hasFilters = #if !openfl_disable_filters object._.__filters != null #else false #end;
			var bitmapMatrix = (object._.__cacheAsBitmapMatrix != null ? object._.__cacheAsBitmapMatrix : object._.__renderTransform);

			var rect = null;

			var colorTransform = ColorTransform._.__pool.get();
			colorTransform._.__copyFrom(object._.__worldColorTransform);
			if (__worldColorTransform != null) colorTransform._.__combine(__worldColorTransform);

			var needRender = (object._.__renderData.cacheBitmap == null
				|| (object._.__renderDirty && (force || object._.__firstChild != null))
				|| object.opaqueBackground != object._.__renderData.cacheBitmapBackground)
				|| (object._.__graphics != null && object._.__graphics._.__softwareDirty)
				|| !object._.__renderData.cacheBitmapColorTransform._.__equals(colorTransform, true);

			if (!needRender
				&& (bitmapMatrix.a != object._.__renderData.cacheBitmapMatrix.a
					|| bitmapMatrix.b != object._.__renderData.cacheBitmapMatrix.b
					|| bitmapMatrix.c != object._.__renderData.cacheBitmapMatrix.c
					|| bitmapMatrix.d != object._.__renderData.cacheBitmapMatrix.d))
			{
				needRender = true;
			}

			if (hasFilters && !needRender)
			{
				for (filter in object._.__filters)
				{
					if (filter._.__renderDirty)
					{
						needRender = true;
						break;
					}
				}
			}

			if (!needRender
				&& object._.__renderData.cacheBitmapData != null
				&& object._.__renderData.cacheBitmapData._.__getCanvas() != null
				&& object._.__renderData.cacheBitmapData._.__getVersion() < object._.__renderData.cacheBitmapData._.__renderData.textureVersion)
			{
				needRender = true;
			}

			// TODO: Handle renderTransform (for scrollRect, displayMatrix changes, etc)
			var updateTransform = (needRender || !object._.__renderData.cacheBitmap._.__worldTransform.equals(object._.__worldTransform));

			object._.__renderData.cacheBitmapMatrix.copyFrom(bitmapMatrix);
			object._.__renderData.cacheBitmapMatrix.tx = 0;
			object._.__renderData.cacheBitmapMatrix.ty = 0;

			// TODO: Handle dimensions better if object has a scrollRect?

			var bitmapWidth = 0, bitmapHeight = 0;
			var filterWidth = 0, filterHeight = 0;
			var offsetX = 0., offsetY = 0.;

			if (updateTransform)
			{
				rect = _Rectangle.__pool.get();

				object._.__getFilterBounds(rect, object._.__renderData.cacheBitmapMatrix);

				filterWidth = Math.ceil(rect.width);
				filterHeight = Math.ceil(rect.height);

				offsetX = rect.x > 0 ? Math.ceil(rect.x) : Math.floor(rect.x);
				offsetY = rect.y > 0 ? Math.ceil(rect.y) : Math.floor(rect.y);

				if (object._.__renderData.cacheBitmapData != null)
				{
					if (filterWidth > object._.__renderData.cacheBitmapData.width
						|| filterHeight > object._.__renderData.cacheBitmapData.height)
					{
						bitmapWidth = Math.ceil(Math.max(filterWidth * 1.25, object._.__renderData.cacheBitmapData.width));
						bitmapHeight = Math.ceil(Math.max(filterHeight * 1.25, object._.__renderData.cacheBitmapData.height));
						needRender = true;
					}
					else
					{
						bitmapWidth = object._.__renderData.cacheBitmapData.width;
						bitmapHeight = object._.__renderData.cacheBitmapData.height;
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
				object._.__renderData.cacheBitmapBackground = object.opaqueBackground;

				if (filterWidth >= 0.5 && filterHeight >= 0.5)
				{
					var needsFill = (object.opaqueBackground != null && (bitmapWidth != filterWidth || bitmapHeight != filterHeight));
					var fillColor = object.opaqueBackground != null ? (0xFF << 24) | object.opaqueBackground : 0;
					var bitmapColor = needsFill ? 0 : fillColor;

					if (object._.__renderData.cacheBitmapData == null
						|| bitmapWidth > object._.__renderData.cacheBitmapData.width
						|| bitmapHeight > object._.__renderData.cacheBitmapData.height)
					{
						object._.__renderData.cacheBitmapData = new BitmapData(bitmapWidth, bitmapHeight, true, bitmapColor);

						if (object._.__renderData.cacheBitmap == null) object._.__renderData.cacheBitmap = new Bitmap();
						object._.__renderData.cacheBitmap._.__bitmapData = object._.__renderData.cacheBitmapData;
						object._.__renderData.cacheBitmapRendererSW = null;
					}
					else
					{
						object._.__renderData.cacheBitmapData.fillRect(object._.__renderData.cacheBitmapData.rect, bitmapColor);
					}

					if (needsFill)
					{
						rect.setTo(0, 0, filterWidth, filterHeight);
						object._.__renderData.cacheBitmapData.fillRect(rect, fillColor);
					}
				}
				else
				{
					ColorTransform._.__pool.release(colorTransform);

					if (__domRenderer != null && object._.__renderData.cacheBitmap != null)
					{
						__domRenderer._.__clearBitmap(object._.__renderData.cacheBitmap);
					}

					object._.__renderData.cacheBitmap = null;
					object._.__renderData.cacheBitmapData = null;
					object._.__renderData.cacheBitmapData2 = null;
					object._.__renderData.cacheBitmapData3 = null;
					object._.__renderData.cacheBitmapRendererSW = null;

					return true;
				}
			}
			else
			{
				// Should we retain these longer?

				object._.__renderData.cacheBitmapData = object._.__renderData.cacheBitmap.bitmapData;
				object._.__renderData.cacheBitmapData2 = null;
				object._.__renderData.cacheBitmapData3 = null;
			}

			if (updateTransform)
			{
				object._.__renderData.cacheBitmap._.__worldTransform.copyFrom(object._.__worldTransform);

				if (bitmapMatrix == object._.__renderTransform)
				{
					object._.__renderData.cacheBitmap._.__renderTransform.identity();
					object._.__renderData.cacheBitmap._.__renderTransform.tx = object._.__renderTransform.tx + offsetX;
					object._.__renderData.cacheBitmap._.__renderTransform.ty = object._.__renderTransform.ty + offsetY;
				}
				else
				{
					object._.__renderData.cacheBitmap._.__renderTransform.copyFrom(object._.__renderData.cacheBitmapMatrix);
					object._.__renderData.cacheBitmap._.__renderTransform.invert();
					object._.__renderData.cacheBitmap._.__renderTransform.concat(object._.__renderTransform);
					object._.__renderData.cacheBitmap._.__renderTransform.tx += offsetX;
					object._.__renderData.cacheBitmap._.__renderTransform.ty += offsetY;
				}
			}

			object._.__renderData.cacheBitmap.smoothing = __allowSmoothing;
			object._.__renderData.cacheBitmap._.__renderable = object._.__renderable;
			object._.__renderData.cacheBitmap._.__worldAlpha = object._.__worldAlpha;
			object._.__renderData.cacheBitmap._.__worldBlendMode = object._.__worldBlendMode;
			object._.__renderData.cacheBitmap._.__worldShader = object._.__worldShader;
			object._.__renderData.cacheBitmap.mask = object._.__mask;

			if (needRender)
			{
				if (object._.__renderData.cacheBitmapRendererSW == null || object._.__renderData.cacheBitmapRendererSW._.__type != CANVAS)
				{
					if (object._.__renderData.cacheBitmapData._.__getCanvas() == null)
					{
						var color = object.opaqueBackground != null ? (0xFF << 24) | object.opaqueBackground : 0;
						object._.__renderData.cacheBitmapData = new BitmapData(bitmapWidth, bitmapHeight, true, color);
						object._.__renderData.cacheBitmap._.__bitmapData = object._.__renderData.cacheBitmapData;
					}

					object._.__renderData.cacheBitmapRendererSW = new CanvasRenderer(object._.__renderData.cacheBitmapData._.__getCanvasContext());
					object._.__renderData.cacheBitmapRendererSW._.__worldTransform = new Matrix();
					object._.__renderData.cacheBitmapRendererSW._.__worldColorTransform = new ColorTransform();
				}

				if (object._.__renderData.cacheBitmapColorTransform == null) object._.__renderData.cacheBitmapColorTransform = new ColorTransform();

				object._.__renderData.cacheBitmapRendererSW._.__stage = object.stage;

				object._.__renderData.cacheBitmapRendererSW._.__allowSmoothing = __allowSmoothing;
				cast(object._.__renderData.cacheBitmapRendererSW, CanvasRenderer)._.__setBlendMode(NORMAL);
				object._.__renderData.cacheBitmapRendererSW._.__worldAlpha = 1 / object._.__worldAlpha;

				object._.__renderData.cacheBitmapRendererSW._.__worldTransform.copyFrom(object._.__renderTransform);
				object._.__renderData.cacheBitmapRendererSW._.__worldTransform.invert();
				object._.__renderData.cacheBitmapRendererSW._.__worldTransform.concat(object._.__renderData.cacheBitmapMatrix);
				object._.__renderData.cacheBitmapRendererSW._.__worldTransform.tx -= offsetX;
				object._.__renderData.cacheBitmapRendererSW._.__worldTransform.ty -= offsetY;

				object._.__renderData.cacheBitmapRendererSW._.__worldColorTransform._.__copyFrom(colorTransform);
				object._.__renderData.cacheBitmapRendererSW._.__worldColorTransform._.__invert();

				object._.__renderData.isCacheBitmapRender = true;

				object._.__renderData.cacheBitmapRendererSW._.__drawBitmapData(object._.__renderData.cacheBitmapData, object, null);

				if (hasFilters)
				{
					var needSecondBitmapData = false;
					var needCopyOfOriginal = false;

					for (filter in object._.__filters)
					{
						if (filter._.__needSecondBitmapData)
						{
							needSecondBitmapData = true;
						}
						if (filter._.__preserveObject)
						{
							needCopyOfOriginal = true;
						}
					}

					var bitmap = object._.__renderData.cacheBitmapData;
					var bitmap2 = null;
					var bitmap3 = null;

					if (needSecondBitmapData)
					{
						if (object._.__renderData.cacheBitmapData2 == null
							|| object._.__renderData.cacheBitmapData2._.__getCanvas() == null
							|| bitmapWidth > object._.__renderData.cacheBitmapData2.width
							|| bitmapHeight > object._.__renderData.cacheBitmapData2.height)
						{
							object._.__renderData.cacheBitmapData2 = new BitmapData(bitmapWidth, bitmapHeight, true, 0);
						}
						else
						{
							object._.__renderData.cacheBitmapData2.fillRect(object._.__renderData.cacheBitmapData2.rect, 0);
						}
						bitmap2 = object._.__renderData.cacheBitmapData2;
					}
					else
					{
						bitmap2 = bitmap;
					}

					if (needCopyOfOriginal)
					{
						if (object._.__renderData.cacheBitmapData3 == null
							|| object._.__renderData.cacheBitmapData3._.__getCanvas() == null
							|| bitmapWidth > object._.__renderData.cacheBitmapData3.width
							|| bitmapHeight > object._.__renderData.cacheBitmapData3.height)
						{
							object._.__renderData.cacheBitmapData3 = new BitmapData(bitmapWidth, bitmapHeight, true, 0);
						}
						else
						{
							object._.__renderData.cacheBitmapData3.fillRect(object._.__renderData.cacheBitmapData3.rect, 0);
						}
						bitmap3 = object._.__renderData.cacheBitmapData3;
					}

					if (object._.__tempPoint == null) object._.__tempPoint = new Point();
					var destPoint = object._.__tempPoint;
					var cacheBitmap, lastBitmap;

					for (filter in object._.__filters)
					{
						if (filter._.__preserveObject)
						{
							bitmap3.copyPixels(bitmap, bitmap.rect, destPoint);
						}

						lastBitmap = filter._.__applyFilter(bitmap2, bitmap, bitmap.rect, destPoint);

						if (filter._.__preserveObject)
						{
							lastBitmap.draw(bitmap3, null, object._.__objectTransform != null ? object._.__objectTransform.colorTransform : null);
						}
						filter._.__renderDirty = false;

						if (needSecondBitmapData && lastBitmap == bitmap2)
						{
							cacheBitmap = bitmap;
							bitmap = bitmap2;
							bitmap2 = cacheBitmap;
						}
					}

					if (object._.__renderData.cacheBitmapData != bitmap)
					{
						// TODO: Fix issue with swapping __renderData.cacheBitmap._.__bitmapData
						// __renderData.cacheBitmapData.copyPixels (bitmap, bitmap.rect, destPoint);

						// Adding __renderData.cacheBitmapRendererSW = null; makes this work
						cacheBitmap = object._.__renderData.cacheBitmapData;
						object._.__renderData.cacheBitmapData = bitmap;
						object._.__renderData.cacheBitmapData2 = cacheBitmap;
						object._.__renderData.cacheBitmap._.__bitmapData = object._.__renderData.cacheBitmapData;
						object._.__renderData.cacheBitmapRendererSW = null;
					}

					object._.__renderData.cacheBitmap._.__imageVersion = object._.__renderData.cacheBitmapData._.__renderData.textureVersion;
				}

				object._.__renderData.cacheBitmapColorTransform._.__copyFrom(colorTransform);

				if (!object._.__renderData.cacheBitmapColorTransform._.__isDefault(true))
				{
					object._.__renderData.cacheBitmapColorTransform.alphaMultiplier = 1;
					object._.__renderData.cacheBitmapData.colorTransform(object._.__renderData.cacheBitmapData.rect,
						object._.__renderData.cacheBitmapColorTransform);
				}

				object._.__renderData.isCacheBitmapRender = false;
			}

			if (updateTransform)
			{
				_Rectangle.__pool.release(rect);
			}

			updated = updateTransform;

			ColorTransform._.__pool.release(colorTransform);
		}
		else if (object._.__renderData.cacheBitmap != null)
		{
			if (__domRenderer != null && object._.__renderData.cacheBitmap != null)
			{
				__domRenderer._.__clearBitmap(object._.__renderData.cacheBitmap);
			}

			object._.__renderData.cacheBitmap = null;
			object._.__renderData.cacheBitmapData = null;
			object._.__renderData.cacheBitmapData2 = null;
			object._.__renderData.cacheBitmapData3 = null;
			object._.__renderData.cacheBitmapColorTransform = null;
			object._.__renderData.cacheBitmapRendererSW = null;

			updated = true;
		}

		return updated;
	}
}
#end
