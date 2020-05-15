package openfl.display;

#if openfl_html5
import openfl.text._internal.HTMLParser;
import openfl.display._internal.*;
import openfl.display.Bitmap;
import openfl.display.BitmapData;
import openfl.display.BlendMode;
import openfl.display.DisplayObject;
import openfl.display.DisplayObjectContainer;
import openfl.display.IBitmapDrawable;
import openfl.display._DisplayObject;
import openfl.display.SimpleButton;
import openfl.display.Tilemap;
import openfl.events.RenderEvent;
import openfl.events._RenderEvent;
import openfl.events._Event;
import openfl.filters._BitmapFilter;
import openfl.geom.Point;
import openfl.geom._ColorTransform;
import openfl.media.Video;
import openfl.text.TextField;
import openfl.text._TextField;
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
@:noCompletion
class _CanvasRenderer extends _DisplayObjectRenderer
{
	public var context:#if (lime || openfl_html5) Canvas2DRenderContext #else Dynamic #end;
	public var pixelRatio:Float = 1;

	public var __colorTransform:ColorTransform;
	public var __domRenderer:#if openfl.renderer_dom DOMRenderer #else Dynamic #end;
	public var __transform:Matrix;

	private var canvasRenderer:CanvasRenderer;

	public function new(canvasRenderer:CanvasRenderer, context:Canvas2DRenderContext)
	{
		this.canvasRenderer = canvasRenderer;

		super(canvasRenderer);

		this.context = context;

		__colorTransform = new ColorTransform();
		__transform = new Matrix();

		__type = CANVAS;
	}

	public function applySmoothing(context:Canvas2DRenderContext, value:Bool):Void
	{
		context.imageSmoothingEnabled = value;
	}

	public function setTransform(transform:Matrix, context:Canvas2DRenderContext = null):Void
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

			if (!(__stage._ : _Stage).__transparent && (__stage._ : _Stage).__clearBeforeRender)
			{
				context.fillStyle = (__stage._ : _Stage).__colorString;
				context.fillRect(0, 0, __stage.stageWidth * (__stage._ : _Stage).__contentsScaleFactor,
					__stage.stageHeight * (__stage._ : _Stage).__contentsScaleFactor);
			}
			else if ((__stage._ : _Stage).__transparent && (__stage._ : _Stage).__clearBeforeRender)
			{
				context.clearRect(0, 0, __stage.stageWidth * (__stage._ : _Stage).__contentsScaleFactor,
					__stage.stageHeight * (__stage._ : _Stage).__contentsScaleFactor);
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

		var context = (bitmapData._ : _BitmapData).__getCanvasContext(true);

		if (!__allowSmoothing) applySmoothing(context, false);

		__render(source);

		if (!__allowSmoothing) applySmoothing(context, true);

		context.setTransform(1, 0, 0, 1, 0, 0);
		// buffer.__srcImageData = null;
		// buffer.data = null;

		(bitmapData._ : _BitmapData).__setDirty();

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
		if (!(object._ : _DisplayObject).__renderData.isCacheBitmapRender && (object._ : _DisplayObject).__mask != null)
		{
			__popMask();
		}

		if (handleScrollRect && (object._ : _DisplayObject).__scrollRect != null)
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

		setTransform((mask._ : _DisplayObject).__renderTransform, context);

		context.beginPath();
		__renderMask(mask);
		context.closePath();

		context.clip();
	}

	public function __pushMaskObject(object:DisplayObject, handleScrollRect:Bool = true):Void
	{
		if (handleScrollRect && (object._ : _DisplayObject).__scrollRect != null)
		{
			__pushMaskRect((object._ : _DisplayObject).__scrollRect, (object._ : _DisplayObject).__renderTransform);
		}

		if (!(object._ : _DisplayObject).__renderData.isCacheBitmapRender && (object._ : _DisplayObject).__mask != null)
		{
			__pushMask((object._ : _DisplayObject).__mask);
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
			if ((object._ : _DisplayObject).__type != null)
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
		__updateCacheBitmap(bitmap, /*!__worldColorTransform.__isDefault ()*/ false);

		if ((bitmap._ : _Bitmap).__bitmapData != null && ((bitmap._ : _Bitmap).__bitmapData._ : _BitmapData).__getCanvas() != null)
		{
			(bitmap._ : _Bitmap).__imageVersion = ((bitmap._ : _Bitmap).__bitmapData._ : _BitmapData).__getVersion();
		}

		if ((bitmap._ : _Bitmap).__renderData.cacheBitmap != null && !(bitmap._ : _Bitmap).__renderData.isCacheBitmapRender)
		{
			CanvasBitmap.render((bitmap._ : _Bitmap).__renderData.cacheBitmap, this.canvasRenderer);
		}
		else
		{
			CanvasDisplayObject.render(bitmap, this.canvasRenderer);
			CanvasBitmap.render(bitmap, this.canvasRenderer);
		}
	}

	public function __renderBitmapData(bitmapData:BitmapData):Void
	{
		if (!bitmapData.readable) return;

		context.globalAlpha = 1;

		setTransform((bitmapData._ : _BitmapData).__renderTransform, context);

		context.drawImage((bitmapData._ : _BitmapData).__getElement(), 0, 0, bitmapData.width, bitmapData.height);
	}

	public function __renderDisplayObject(object:DisplayObject):Void
	{
		if (object != null && (object._ : _DisplayObject).__type != null)
		{
			switch ((object._ : _DisplayObject).__type)
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

			if ((object._ : _DisplayObject).__customRenderEvent != null)
			{
				var event = (object._ : _DisplayObject).__customRenderEvent;
				event.allowSmoothing = __allowSmoothing;
				event.objectMatrix.copyFrom((object._ : _DisplayObject).__renderTransform);
				event.objectColorTransform._.__copyFrom((object._ : _DisplayObject).__worldColorTransform);
				(event._ : _RenderEvent).renderer = this.canvasRenderer;
				(event._ : _Event).type = RenderEvent.RENDER_CANVAS;

				__setBlendMode((object._ : _DisplayObject).__worldBlendMode);
				__pushMaskObject(object);

				object.dispatchEvent(event);

				__popMaskObject(object);
			}
		}
	}

	public function __renderDisplayObjectContainer(container:DisplayObjectContainer):Void
	{
		if (__domRenderer == null) (container._ : _DisplayObjectContainer).__cleanupRemovedChildren();

		if (!(container._ : _DisplayObjectContainer).__renderable
			|| (container._ : _DisplayObjectContainer).__worldAlpha <= 0
				|| (container.mask != null && (container.mask.width <= 0 || container.mask.height <= 0))) return;

		__updateCacheBitmap(container, /*!__worldColorTransform.__isDefault ()*/ false);

		if ((container._ : _DisplayObjectContainer).__renderData.cacheBitmap != null
			&& !(container._ : _DisplayObjectContainer).__renderData.isCacheBitmapRender)
		{
			CanvasBitmap.render((container._ : _DisplayObjectContainer).__renderData.cacheBitmap, this.canvasRenderer);
		}
		else
		{
			CanvasDisplayObject.render(container, this.canvasRenderer);
		}

		if ((container._ : _DisplayObjectContainer).__renderData.cacheBitmap != null
			&& !(container._ : _DisplayObjectContainer).__renderData.isCacheBitmapRender) return;

		__pushMaskObject(container);

		var child = (container._ : _DisplayObjectContainer).__firstChild;
		if (__stage != null)
		{
			while (child != null)
			{
				__renderDisplayObject(child);
				(child._ : _DisplayObject).__renderDirty = false;
				child = (child._ : _DisplayObject).__nextSibling;
			}

				(container._ : _DisplayObjectContainer).__renderDirty = false;
		}
		else
		{
			while (child != null)
			{
				__renderDisplayObject(child);
				child = (child._ : _DisplayObject).__nextSibling;
			}
		}

		__popMaskObject(container);
	}

	public function __renderMask(mask:DisplayObject):Void
	{
		if (mask != null)
		{
			switch ((mask._ : _DisplayObject).__type)
			{
				case BITMAP:
					context.rect(0, 0, mask.width, mask.height);

				case DISPLAY_OBJECT_CONTAINER, MOVIE_CLIP:
					var container:DisplayObjectContainer = cast mask;
					if (__domRenderer == null) (container._ : _DisplayObjectContainer).__cleanupRemovedChildren();

					if ((container._ : _DisplayObjectContainer).__graphics != null)
					{
						CanvasGraphics.renderMask((container._ : _DisplayObjectContainer).__graphics, this.canvasRenderer);
					}

					var child = (container._ : _DisplayObjectContainer).__firstChild;
					while (child != null)
					{
						__renderMask(child);
						child = (child._ : _DisplayObject).__nextSibling;
					}

				case DOM_ELEMENT:

				case SIMPLE_BUTTON:
					var button:SimpleButton = cast mask;
					__renderMask((button._ : _SimpleButton).__currentState);

				default:
					if ((mask._ : _DisplayObject).__graphics != null)
					{
						CanvasGraphics.renderMask((mask._ : _DisplayObject).__graphics, this.canvasRenderer);
					}
			}
		}
	}

	public function __renderShape(shape:DisplayObject):Void
	{
		if (shape.mask == null || (shape.mask.width > 0 && shape.mask.height > 0))
		{
			__updateCacheBitmap(shape, /*!__worldColorTransform.__isDefault ()*/ false);

			if ((shape._ : _DisplayObject).__renderData.cacheBitmap != null
				&& !(shape._ : _DisplayObject).__renderData.isCacheBitmapRender)
			{
				CanvasBitmap.render((shape._ : _DisplayObject).__renderData.cacheBitmap, this.canvasRenderer);
			}
			else
			{
				CanvasDisplayObject.render(shape, this.canvasRenderer);
			}
		}
	}

	public function __renderSimpleButton(button:SimpleButton):Void
	{
		if (!(button._ : _SimpleButton).__renderable
			|| (button._ : _SimpleButton).__worldAlpha <= 0 || (button._ : _SimpleButton).__currentState == null) return;

		__pushMaskObject(button);
		__renderDisplayObject((button._ : _SimpleButton).__currentState);
		__popMaskObject(button);
	}

	public function __renderTextField(textField:TextField):Void
	{
		#if openfl_html5
		// TODO: Better DOM workaround on cacheAsBitmap

		if (__domRenderer != null && !(textField._ : _TextField).__renderedOnCanvasWhileOnDOM)
		{
			(textField._ : _TextField).__renderedOnCanvasWhileOnDOM = true;

			if (textField.type == TextFieldType.INPUT)
			{
				textField.replaceText(0, (textField._ : _TextField).__text.length, (textField._ : _TextField).__text);
			}

			if ((textField._ : _TextField).__isHTML)
			{
				(textField._ : _TextField).__updateText(HTMLParser.parse((textField._ : _TextField).__text, (textField._ : _TextField).__textFormat,
					(textField._ : _TextField).__textEngine.textFormatRanges));
			}

				(textField._ : _TextField).__dirty = true;
			(textField._ : _TextField).__layoutDirty = true;
			(textField._ : _TextField).__setRenderDirty();
		}

		if (textField.mask == null || (textField.mask.width > 0 && textField.mask.height > 0))
		{
			__updateCacheBitmap(textField, (textField._ : _TextField).__dirty);

			if ((textField._ : _TextField).__renderData.cacheBitmap != null
				&& !(textField._ : _TextField).__renderData.isCacheBitmapRender)
			{
				CanvasBitmap.render((textField._ : _TextField).__renderData.cacheBitmap, this.canvasRenderer);
			}
			else
			{
				CanvasTextField.render(textField, this.canvasRenderer, (textField._ : _TextField).__worldTransform);

				var smoothingEnabled = false;

				if ((textField._ : _TextField).__textEngine.antiAliasType == ADVANCED
					&& (textField._ : _TextField).__textEngine.gridFitType == PIXEL)
				{
					smoothingEnabled = context.imageSmoothingEnabled;

					if (smoothingEnabled)
					{
						context.imageSmoothingEnabled = false;
					}
				}

				CanvasDisplayObject.render(textField, this.canvasRenderer);

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
		__updateCacheBitmap(tilemap, /*!__worldColorTransform.__isDefault ()*/ false);

		if ((tilemap._ : _Tilemap).__renderData.cacheBitmap != null && !(tilemap._ : _Tilemap).__renderData.isCacheBitmapRender)
		{
			CanvasBitmap.render((tilemap._ : _Tilemap).__renderData.cacheBitmap, this.canvasRenderer);
		}
		else
		{
			CanvasDisplayObject.render(tilemap, this.canvasRenderer);
			CanvasTilemap.render(tilemap, this.canvasRenderer);
		}
	}

	public function __renderVideo(video:Video):Void
	{
		CanvasVideo.render(video, this.canvasRenderer);
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

		if ((object._ : _DisplayObject).__renderData.isCacheBitmapRender) return false;
		var updated = false;

		if (object.cacheAsBitmap
			|| !(object._ : _DisplayObject).__worldColorTransform._.__isDefault(true)
				|| (__worldColorTransform != null && !__worldColorTransform._.__isDefault(true)))
		{
			if ((object._ : _DisplayObject).__renderData.cacheBitmapMatrix == null)
			{
				(object._ : _DisplayObject).__renderData.cacheBitmapMatrix = new Matrix();
			}

			var hasFilters = #if !openfl_disable_filters (object._ : _DisplayObject).__filters != null #else false #end;
			var bitmapMatrix = ((object._ : _DisplayObject).__cacheAsBitmapMatrix != null ? (object._ : _DisplayObject)
				.__cacheAsBitmapMatrix : (object._ : _DisplayObject).__renderTransform);

			var rect = null;

			var colorTransform = _ColorTransform.__pool.get();
			colorTransform._.__copyFrom((object._ : _DisplayObject).__worldColorTransform);
			if (__worldColorTransform != null) colorTransform._.__combine(__worldColorTransform);

			var needRender = ((object._ : _DisplayObject).__renderData.cacheBitmap == null
				|| ((object._ : _DisplayObject).__renderDirty && (force || (object._ : _DisplayObject).__firstChild != null))
				|| object.opaqueBackground != (object._ : _DisplayObject).__renderData.cacheBitmapBackground)
				|| ((object._ : _DisplayObject).__graphics != null
					&& ((object._ : _DisplayObject).__graphics._ : _Graphics).__softwareDirty)
				|| !(object._ : _DisplayObject).__renderData.cacheBitmapColorTransform._.__equals(colorTransform, true);

			if (!needRender
				&& (bitmapMatrix.a != (object._ : _DisplayObject).__renderData.cacheBitmapMatrix.a
					|| bitmapMatrix.b != (object._ : _DisplayObject).__renderData.cacheBitmapMatrix.b
						|| bitmapMatrix.c != (object._ : _DisplayObject).__renderData.cacheBitmapMatrix.c
							|| bitmapMatrix.d != (object._ : _DisplayObject).__renderData.cacheBitmapMatrix.d))
			{
				needRender = true;
			}

			if (hasFilters && !needRender)
			{
				for (filter in (object._ : _DisplayObject).__filters)
				{
					if ((filter._ : _BitmapFilter).__renderDirty)
					{
						needRender = true;
						break;
					}
				}
			}

			if (!needRender
				&& (object._ : _DisplayObject).__renderData.cacheBitmapData != null
					&& ((object._ : _DisplayObject).__renderData.cacheBitmapData._ : _BitmapData).__getCanvas() != null
						&& ((object._ : _DisplayObject).__renderData.cacheBitmapData._ : _BitmapData).__getVersion() < ((object._ : _DisplayObject)
							.__renderData.cacheBitmapData._ : _BitmapData).__renderData.textureVersion)
			{
				needRender = true;
			}

			// TODO: Handle renderTransform (for scrollRect, displayMatrix changes, etc)
			var updateTransform = (needRender
				|| !((object._ : _DisplayObject).__renderData.cacheBitmap._ : _Bitmap).__worldTransform._.equals((object._ : _DisplayObject).__worldTransform));

			(object._ : _DisplayObject).__renderData.cacheBitmapMatrix.copyFrom(bitmapMatrix);
			(object._ : _DisplayObject).__renderData.cacheBitmapMatrix.tx = 0;
			(object._ : _DisplayObject).__renderData.cacheBitmapMatrix.ty = 0;

			// TODO: Handle dimensions better if object has a scrollRect?

			var bitmapWidth = 0, bitmapHeight = 0;
			var filterWidth = 0, filterHeight = 0;
			var offsetX = 0., offsetY = 0.;

			if (updateTransform)
			{
				rect = _Rectangle.__pool.get();

				(object._ : _DisplayObject).__getFilterBounds(rect, (object._ : _DisplayObject).__renderData.cacheBitmapMatrix);

				filterWidth = Math.ceil(rect.width);
				filterHeight = Math.ceil(rect.height);

				offsetX = rect.x > 0 ? Math.ceil(rect.x) : Math.floor(rect.x);
				offsetY = rect.y > 0 ? Math.ceil(rect.y) : Math.floor(rect.y);

				if ((object._ : _DisplayObject).__renderData.cacheBitmapData != null)
				{
					if (filterWidth > (object._ : _DisplayObject).__renderData.cacheBitmapData.width
						|| filterHeight > (object._ : _DisplayObject).__renderData.cacheBitmapData.height)
					{
						bitmapWidth = Math.ceil(Math.max(filterWidth * 1.25, (object._ : _DisplayObject).__renderData.cacheBitmapData.width));
						bitmapHeight = Math.ceil(Math.max(filterHeight * 1.25, (object._ : _DisplayObject).__renderData.cacheBitmapData.height));
						needRender = true;
					}
					else
					{
						bitmapWidth = (object._ : _DisplayObject).__renderData.cacheBitmapData.width;
						bitmapHeight = (object._ : _DisplayObject).__renderData.cacheBitmapData.height;
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
				(object._ : _DisplayObject).__renderData.cacheBitmapBackground = object.opaqueBackground;

				if (filterWidth >= 0.5 && filterHeight >= 0.5)
				{
					var needsFill = (object.opaqueBackground != null && (bitmapWidth != filterWidth || bitmapHeight != filterHeight));
					var fillColor = object.opaqueBackground != null ? (0xFF << 24) | object.opaqueBackground : 0;
					var bitmapColor = needsFill ? 0 : fillColor;

					if ((object._ : _DisplayObject).__renderData.cacheBitmapData == null
						|| bitmapWidth > (object._ : _DisplayObject).__renderData.cacheBitmapData.width
							|| bitmapHeight > (object._ : _DisplayObject).__renderData.cacheBitmapData.height)
					{
						(object._ : _DisplayObject).__renderData.cacheBitmapData = new BitmapData(bitmapWidth, bitmapHeight, true, bitmapColor);

						if ((object._ : _DisplayObject).__renderData.cacheBitmap == null) (object._ : _DisplayObject).__renderData.cacheBitmap = new Bitmap();
						((object._ : _DisplayObject).__renderData.cacheBitmap._ : _Bitmap).__bitmapData = (object._ : _DisplayObject)
							.__renderData.cacheBitmapData;
						(object._ : _DisplayObject).__renderData.cacheBitmapRendererSW = null;
					}
					else
					{
						(object._ : _DisplayObject).__renderData.cacheBitmapData.fillRect((object._ : _DisplayObject).__renderData.cacheBitmapData.rect,
							bitmapColor);
					}

					if (needsFill)
					{
						rect.setTo(0, 0, filterWidth, filterHeight);
						(object._ : _DisplayObject).__renderData.cacheBitmapData.fillRect(rect, fillColor);
					}
				}
				else
				{
					_ColorTransform.__pool.release(colorTransform);

					#if openfl.renderer_dom
					if (__domRenderer != null && (object._ : _DisplayObject).__renderData.cacheBitmap != null)
					{
						(__domRenderer._ : _DOMRenderer).__clearBitmap((object._ : _DisplayObject).__renderData.cacheBitmap);
					}
					#end

					(object._ : _DisplayObject).__renderData.cacheBitmap = null;
					(object._ : _DisplayObject).__renderData.cacheBitmapData = null;
					(object._ : _DisplayObject).__renderData.cacheBitmapData2 = null;
					(object._ : _DisplayObject).__renderData.cacheBitmapData3 = null;
					(object._ : _DisplayObject).__renderData.cacheBitmapRendererSW = null;

					return true;
				}
			}
			else
			{
				// Should we retain these longer?

				(object._ : _DisplayObject).__renderData.cacheBitmapData = (object._ : _DisplayObject).__renderData.cacheBitmap.bitmapData;
				(object._ : _DisplayObject).__renderData.cacheBitmapData2 = null;
				(object._ : _DisplayObject).__renderData.cacheBitmapData3 = null;
			}

			if (updateTransform)
			{
				((object._ : _DisplayObject).__renderData.cacheBitmap._ : _Bitmap).__worldTransform.copyFrom((object._ : _DisplayObject).__worldTransform);

				if (bitmapMatrix == (object._ : _DisplayObject).__renderTransform)
				{
					((object._ : _DisplayObject).__renderData.cacheBitmap._ : _Bitmap).__renderTransform.identity();
					((object._ : _DisplayObject).__renderData.cacheBitmap._ : _Bitmap).__renderTransform.tx = (object._ : _DisplayObject).__renderTransform.tx
						+ offsetX;
					((object._ : _DisplayObject).__renderData.cacheBitmap._ : _Bitmap).__renderTransform.ty = (object._ : _DisplayObject).__renderTransform.ty
						+ offsetY;
				}
				else
				{
					((object._ : _DisplayObject).__renderData.cacheBitmap._ : _Bitmap).__renderTransform.copyFrom((object._ : _DisplayObject)
						.__renderData.cacheBitmapMatrix);
					((object._ : _DisplayObject).__renderData.cacheBitmap._ : _Bitmap).__renderTransform.invert();
					((object._ : _DisplayObject).__renderData.cacheBitmap._ : _Bitmap).__renderTransform.concat((object._ : _DisplayObject).__renderTransform);
					((object._ : _DisplayObject).__renderData.cacheBitmap._ : _Bitmap).__renderTransform.tx += offsetX;
					((object._ : _DisplayObject).__renderData.cacheBitmap._ : _Bitmap).__renderTransform.ty += offsetY;
				}
			}

				(object._ : _DisplayObject).__renderData.cacheBitmap.smoothing = __allowSmoothing;
			((object._ : _DisplayObject).__renderData.cacheBitmap._ : _Bitmap).__renderable = (object._ : _DisplayObject).__renderable;
			((object._ : _DisplayObject).__renderData.cacheBitmap._ : _Bitmap).__worldAlpha = (object._ : _DisplayObject).__worldAlpha;
			((object._ : _DisplayObject).__renderData.cacheBitmap._ : _Bitmap).__worldBlendMode = (object._ : _DisplayObject).__worldBlendMode;
			((object._ : _DisplayObject).__renderData.cacheBitmap._ : _Bitmap).__worldShader = (object._ : _DisplayObject).__worldShader;
			(object._ : _DisplayObject).__renderData.cacheBitmap.mask = (object._ : _DisplayObject).__mask;

			if (needRender)
			{
				if ((object._ : _DisplayObject).__renderData.cacheBitmapRendererSW == null
					|| ((object._ : _DisplayObject).__renderData.cacheBitmapRendererSW._ : _DisplayObjectRenderer).__type != CANVAS)
				{
					if (((object._ : _DisplayObject).__renderData.cacheBitmapData._ : _BitmapData).__getCanvas() == null)
					{
						var color = object.opaqueBackground != null ? (0xFF << 24) | object.opaqueBackground : 0;
							(object._ : _DisplayObject).__renderData.cacheBitmapData = new BitmapData(bitmapWidth, bitmapHeight, true, color);
						((object._ : _DisplayObject).__renderData.cacheBitmap._ : _Bitmap).__bitmapData = (object._ : _DisplayObject)
							.__renderData.cacheBitmapData;
					}

						(object._ : _DisplayObject).__renderData.cacheBitmapRendererSW = new CanvasRenderer(((object._ : _DisplayObject)
							.__renderData.cacheBitmapData._ : _BitmapData).__getCanvasContext());
					((object._ : _DisplayObject).__renderData.cacheBitmapRendererSW._ : _DisplayObjectRenderer).__worldTransform = new Matrix();
					((object._ : _DisplayObject).__renderData.cacheBitmapRendererSW._ : _DisplayObjectRenderer).__worldColorTransform = new ColorTransform();
				}

				if ((object._ : _DisplayObject).__renderData.cacheBitmapColorTransform == null) (object._ : _DisplayObject)
					.__renderData.cacheBitmapColorTransform = new ColorTransform();

				((object._ : _DisplayObject).__renderData.cacheBitmapRendererSW._ : _DisplayObjectRenderer).__stage = object.stage;

				((object._ : _DisplayObject).__renderData.cacheBitmapRendererSW._ : _DisplayObjectRenderer).__allowSmoothing = __allowSmoothing;
				((object._ : _DisplayObject).__renderData.cacheBitmapRendererSW._ : _CanvasRenderer).__setBlendMode(NORMAL);
				((object._ : _DisplayObject).__renderData.cacheBitmapRendererSW._ : _DisplayObjectRenderer).__worldAlpha = 1 / (object._ : _DisplayObject)
					.__worldAlpha;

				((object._ : _DisplayObject).__renderData.cacheBitmapRendererSW._ : _DisplayObjectRenderer)
					.__worldTransform.copyFrom((object._ : _DisplayObject).__renderTransform);
				((object._ : _DisplayObject).__renderData.cacheBitmapRendererSW._ : _DisplayObjectRenderer).__worldTransform.invert();
				((object._ : _DisplayObject).__renderData.cacheBitmapRendererSW._ : _DisplayObjectRenderer).__worldTransform.concat((object._ : _DisplayObject)
					.__renderData.cacheBitmapMatrix);
				((object._ : _DisplayObject).__renderData.cacheBitmapRendererSW._ : _DisplayObjectRenderer).__worldTransform.tx -= offsetX;
				((object._ : _DisplayObject).__renderData.cacheBitmapRendererSW._ : _DisplayObjectRenderer).__worldTransform.ty -= offsetY;

				((object._ : _DisplayObject).__renderData.cacheBitmapRendererSW._ : _DisplayObjectRenderer).__worldColorTransform._.__copyFrom(colorTransform);
				((object._ : _DisplayObject).__renderData.cacheBitmapRendererSW._ : _DisplayObjectRenderer).__worldColorTransform._.__invert();

				(object._ : _DisplayObject).__renderData.isCacheBitmapRender = true;

				(((object._ : _DisplayObject).__renderData.cacheBitmapRendererSW._ : _DisplayObjectRenderer) : _DisplayObjectRenderer)
					.__drawBitmapData((object._ : _DisplayObject).__renderData.cacheBitmapData, object, null);

				if (hasFilters)
				{
					var needSecondBitmapData = false;
					var needCopyOfOriginal = false;

					for (filter in (object._ : _DisplayObject).__filters)
					{
						if ((filter._ : _BitmapFilter).__needSecondBitmapData)
						{
							needSecondBitmapData = true;
						}
						if ((filter._ : _BitmapFilter).__preserveObject)
						{
							needCopyOfOriginal = true;
						}
					}

					var bitmap = (object._ : _DisplayObject).__renderData.cacheBitmapData;
					var bitmap2 = null;
					var bitmap3 = null;

					if (needSecondBitmapData)
					{
						if ((object._ : _DisplayObject).__renderData.cacheBitmapData2 == null
							|| ((object._ : _DisplayObject).__renderData.cacheBitmapData2._ : _BitmapData).__getCanvas() == null
								|| bitmapWidth > (object._ : _DisplayObject).__renderData.cacheBitmapData2.width
									|| bitmapHeight > (object._ : _DisplayObject).__renderData.cacheBitmapData2.height)
						{
							(object._ : _DisplayObject).__renderData.cacheBitmapData2 = new BitmapData(bitmapWidth, bitmapHeight, true, 0);
						}
						else
						{
							(object._ : _DisplayObject).__renderData.cacheBitmapData2.fillRect((object._ : _DisplayObject).__renderData.cacheBitmapData2.rect,
								0);
						}
						bitmap2 = (object._ : _DisplayObject).__renderData.cacheBitmapData2;
					}
					else
					{
						bitmap2 = bitmap;
					}

					if (needCopyOfOriginal)
					{
						if ((object._ : _DisplayObject).__renderData.cacheBitmapData3 == null
							|| ((object._ : _DisplayObject).__renderData.cacheBitmapData3._ : _BitmapData).__getCanvas() == null
								|| bitmapWidth > (object._ : _DisplayObject).__renderData.cacheBitmapData3.width
									|| bitmapHeight > (object._ : _DisplayObject).__renderData.cacheBitmapData3.height)
						{
							(object._ : _DisplayObject).__renderData.cacheBitmapData3 = new BitmapData(bitmapWidth, bitmapHeight, true, 0);
						}
						else
						{
							(object._ : _DisplayObject).__renderData.cacheBitmapData3.fillRect((object._ : _DisplayObject).__renderData.cacheBitmapData3.rect,
								0);
						}
						bitmap3 = (object._ : _DisplayObject).__renderData.cacheBitmapData3;
					}

					if ((object._ : _DisplayObject).__tempPoint == null) (object._ : _DisplayObject).__tempPoint = new Point();
					var destPoint = (object._ : _DisplayObject).__tempPoint;
					var cacheBitmap, lastBitmap;

					for (filter in (object._ : _DisplayObject).__filters)
					{
						if ((filter._ : _BitmapFilter).__preserveObject)
						{
							bitmap3.copyPixels(bitmap, bitmap.rect, destPoint);
						}

						lastBitmap = (filter._ : _BitmapFilter).__applyFilter(bitmap2, bitmap, bitmap.rect, destPoint);

						if ((filter._ : _BitmapFilter).__preserveObject)
						{
							lastBitmap.draw(bitmap3, null,
								(object._ : _DisplayObject).__objectTransform != null ? (object._ : _DisplayObject).__objectTransform.colorTransform : null);
						}
							(filter._ : _BitmapFilter).__renderDirty = false;

						if (needSecondBitmapData && lastBitmap == bitmap2)
						{
							cacheBitmap = bitmap;
							bitmap = bitmap2;
							bitmap2 = cacheBitmap;
						}
					}

					if ((object._ : _DisplayObject).__renderData.cacheBitmapData != bitmap)
					{
						// TODO: Fix issue with swapping __renderData.cacheBitmap.__bitmapData
						// __renderData.cacheBitmapData.copyPixels (bitmap, bitmap.rect, destPoint);

						// Adding __renderData.cacheBitmapRendererSW = null; makes this work
						cacheBitmap = (object._ : _DisplayObject).__renderData.cacheBitmapData;
						(object._ : _DisplayObject).__renderData.cacheBitmapData = bitmap;
						(object._ : _DisplayObject).__renderData.cacheBitmapData2 = cacheBitmap;
						((object._ : _DisplayObject).__renderData.cacheBitmap._ : _Bitmap).__bitmapData = (object._ : _DisplayObject)
							.__renderData.cacheBitmapData;
						(object._ : _DisplayObject).__renderData.cacheBitmapRendererSW = null;
					}

						((object._ : _DisplayObject).__renderData.cacheBitmap._ : _Bitmap).__imageVersion = ((object._ : _DisplayObject)
							.__renderData.cacheBitmapData._ : _BitmapData).__renderData.textureVersion;
				}

					(object._ : _DisplayObject).__renderData.cacheBitmapColorTransform._.__copyFrom(colorTransform);

				if (!(object._ : _DisplayObject).__renderData.cacheBitmapColorTransform._.__isDefault(true))
				{
					(object._ : _DisplayObject).__renderData.cacheBitmapColorTransform.alphaMultiplier = 1;
					(object._ : _DisplayObject).__renderData.cacheBitmapData.colorTransform((object._ : _DisplayObject).__renderData.cacheBitmapData.rect,
						(object._ : _DisplayObject).__renderData.cacheBitmapColorTransform);
				}

					(object._ : _DisplayObject).__renderData.isCacheBitmapRender = false;
			}

			if (updateTransform)
			{
				_Rectangle.__pool.release(rect);
			}

			updated = updateTransform;

			_ColorTransform.__pool.release(colorTransform);
		}
		else if ((object._ : _DisplayObject).__renderData.cacheBitmap != null)
		{
			#if openfl.renderer_dom
			if (__domRenderer != null && (object._ : _DisplayObject).__renderData.cacheBitmap != null)
			{
				(__domRenderer._ : _DOMRenderer).__clearBitmap((object._ : _DisplayObject).__renderData.cacheBitmap);
			}
			#end

			(object._ : _DisplayObject).__renderData.cacheBitmap = null;
			(object._ : _DisplayObject).__renderData.cacheBitmapData = null;
			(object._ : _DisplayObject).__renderData.cacheBitmapData2 = null;
			(object._ : _DisplayObject).__renderData.cacheBitmapData3 = null;
			(object._ : _DisplayObject).__renderData.cacheBitmapColorTransform = null;
			(object._ : _DisplayObject).__renderData.cacheBitmapRendererSW = null;

			updated = true;
		}

		return updated;
	}
}
#end
