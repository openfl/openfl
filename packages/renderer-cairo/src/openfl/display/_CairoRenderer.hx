package openfl.display;

#if openfl_cairo
import lime.math.Matrix3;
import lime.graphics.cairo.Cairo;
import lime.graphics.cairo.CairoFilter;
import lime.graphics.cairo.CairoOperator;
import lime.graphics.cairo.CairoPattern;
import openfl.display.Bitmap;
import openfl.display.BitmapData;
import openfl.display.BlendMode;
import openfl.display.CairoRenderer as CairoRendererAPI;
import openfl.display.DisplayObject;
import openfl.display.DisplayObjectContainer;
import openfl.display.IBitmapDrawable;
import openfl.display.Shape;
import openfl.display.SimpleButton;
import openfl.display.Tilemap;
import openfl.events.RenderEvent;
import openfl.media.Video;
import openfl.text.TextField;
import openfl.geom.ColorTransform;
import openfl.geom.Matrix;
import openfl.geom._Matrix;
import openfl.geom.Point;
import openfl.geom.Rectangle;
import openfl.geom._Rectangle;

#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
@:noCompletion
class _CairoRenderer extends _DisplayObjectRenderer
{
	public var cairo:#if lime CairoRenderContext #else Dynamic #end;

	public var __matrix:Matrix;
	public var __matrix3:Matrix3;
	public var __colorTransform:ColorTransform;

	private var cairoRenderer:CairoRenderer;

	public function new(cairo:Cairo)
	{
		this.cairoRenderer = cairoRenderer;

		super(cairoRenderer);

		this.cairo = cairo;

		__colorTransform = new ColorTransform();
		__matrix = new Matrix();
		__matrix3 = new Matrix3();

		__type = CAIRO;
	}

	public function applyMatrix(transform:Matrix, cairo:Cairo = null):Void
	{
		if (cairo == null) cairo = this.cairo;

		__matrix.copyFrom(transform);

		if (this.cairo == cairo && __worldTransform != null)
		{
			__matrix.concat(__worldTransform);
		}

		__matrix3.a = __matrix.a;
		__matrix3.b = __matrix.b;
		__matrix3.c = __matrix.c;
		__matrix3.d = __matrix.d;

		if (__roundPixels)
		{
			__matrix3.tx = Math.round(__matrix.tx);
			__matrix3.ty = Math.round(__matrix.ty);
		}
		else
		{
			__matrix3.tx = __matrix.tx;
			__matrix3.ty = __matrix.ty;
		}

		cairo.matrix = __matrix3;
	}

	public override function __clear():Void
	{
		if (cairo == null) return;

		cairo.identityMatrix();

		if (__stage != null && (__stage._ : _Stage).__clearBeforeRender)
		{
			var cacheBlendMode = __blendMode;
			__setBlendMode(NORMAL);

			cairo.setSourceRGB((__stage._ : _Stage).__colorSplit[0], (__stage._ : _Stage).__colorSplit[1], (__stage._ : _Stage).__colorSplit[2]);
			cairo.paint();

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

		if (source == bitmapData)
		{
			source = bitmapData.clone();
		}

		if (!__allowSmoothing) cairo.antialias = NONE;

		__render(source);

		if (!__allowSmoothing) cairo.antialias = GOOD;

		cairo.target.flush();

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
		cairo.restore();
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
		cairo.restore();
	}

	public function __pushMask(mask:DisplayObject):Void
	{
		cairo.save();

		applyMatrix((mask._ : _DisplayObject).__renderTransform, cairo);

		cairo.newPath();
		__renderMask(mask);
		cairo.clip();
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
		cairo.save();

		applyMatrix(transform, cairo);

		cairo.newPath();
		cairo.rectangle(rect.x, rect.y, rect.width, rect.height);
		cairo.clip();
	}

	public override function __render(object:IBitmapDrawable):Void
	{
		if (cairo == null) return;

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
		__updateCacheBitmap(bitmap, /*!__worldColorTransform._.__isDefault ()*/ false);

		if (bitmap._.__bitmapData != null && bitmap._.__bitmapData._.__getSurface() != null)
		{
			bitmap._.__imageVersion = bitmap._.__bitmapData._.__getVersion();
		}

		if (bitmap._.__renderData.cacheBitmap != null && !bitmap._.__renderData.isCacheBitmapRender)
		{
			CairoBitmap.render(bitmap._.__renderData.cacheBitmap, this.cairoRenderer);
		}
		else
		{
			CairoDisplayObject.render(bitmap, this.cairoRenderer);
			CairoBitmap.render(bitmap, this.cairoRenderer);
		}
	}

	public function __renderBitmapData(bitmapData:BitmapData):Void
	{
		if (!bitmapData.readable) return;

		applyMatrix(bitmapData._.__renderTransform, cairo);

		var surface = bitmapData.getSurface();

		if (surface != null)
		{
			var pattern = CairoPattern.createForSurface(surface);

			if (!__allowSmoothing || cairo.antialias == NONE)
			{
				pattern.filter = CairoFilter.NEAREST;
			}
			else
			{
				pattern.filter = CairoFilter.GOOD;
			}

			cairo.source = pattern;
			cairo.paint();
		}
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
				event.renderer = this.cairoRenderer;
				event.type = RenderEvent.RENDER_CAIRO;

				__setBlendMode((object._ : _DisplayObject).__worldBlendMode);
				__pushMaskObject(object);

				object.dispatchEvent(event);

				__popMaskObject(object);
			}
		}
	}

	public function __renderDisplayObjectContainer(container:DisplayObjectContainer):Void
	{
		(container._ : _DisplayObjectContainer).__cleanupRemovedChildren();

		if (!(container._ : _DisplayObjectContainer).__renderable || (container._ : _DisplayObjectContainer).__worldAlpha <= 0) return;

		__updateCacheBitmap(container, /*!__worldColorTransform._.__isDefault ()*/ false);

		if ((container._ : _DisplayObjectContainer).__renderData.cacheBitmap != null
			&& !(container._ : _DisplayObjectContainer).__renderData.isCacheBitmapRender)
		{
			CairoBitmap.render((container._ : _DisplayObjectContainer).__renderData.cacheBitmap, this.cairoRenderer);
		}
		else
		{
			CairoDisplayObject.render(container, this.cairoRenderer);
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
					cairo.rectangle(0, 0, mask.width, mask.height);

				case DISPLAY_OBJECT_CONTAINER, MOVIE_CLIP:
					var container:DisplayObjectContainer = cast mask;
					(container._ : _DisplayObjectContainer).__cleanupRemovedChildren();

					if ((container._ : _DisplayObjectContainer).__graphics != null)
					{
						CairoGraphics.renderMask((container._ : _DisplayObjectContainer).__graphics, this.cairoRenderer);
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
						CairoGraphics.renderMask((mask._ : _DisplayObject).__graphics, this.cairoRenderer);
					}
			}
		}
	}

	public function __renderShape(shape:DisplayObject):Void
	{
		__updateCacheBitmap(shape, /*!__worldColorTransform._.__isDefault ()*/ false);

		if (shape._.__renderData.cacheBitmap != null && !shape._.__renderData.isCacheBitmapRender)
		{
			CairoBitmap.render(shape._.__renderData.cacheBitmap, this.cairoRenderer);
		}
		else
		{
			CairoDisplayObject.render(shape, this.cairoRenderer);
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
		__updateCacheBitmap(textField, (textField._ : _TextField).__dirty);

		if ((textField._ : _TextField).__renderData.cacheBitmap != null && !(textField._ : _TextField).__renderData.isCacheBitmapRender)
		{
			CairoBitmap.render((textField._ : _TextField).__renderData.cacheBitmap, this.cairoRenderer);
		}
		else
		{
			CairoTextField.render(textField, this.cairoRenderer, (textField._ : _TextField).__worldTransform);
			CairoDisplayObject.render(textField, this.cairoRenderer);
		}
	}

	public function __renderTilemap(tilemap:Tilemap):Void
	{
		__updateCacheBitmap(tilemap, /*!__worldColorTransform._.__isDefault ()*/ false);

		if ((tilemap._ : _Tilemap).__renderData.cacheBitmap != null && !(tilemap._ : _Tilemap).__renderData.isCacheBitmapRender)
		{
			CairoBitmap.render((tilemap._ : _Tilemap).__renderData.cacheBitmap, this.cairoRenderer);
		}
		else
		{
			CairoDisplayObject.render(tilemap, this.cairoRenderer);
			CairoTilemap.render(tilemap, this.cairoRenderer);
		}
	}

	public function __renderVideo(video:Video):Void
	{
		// CanvasVideo.render(video, this.cairoRenderer);
	}

	public function __setBlendMode(value:BlendMode):Void
	{
		if (__overrideBlendMode != null) value = __overrideBlendMode;
		if (__blendMode == value) return;

		__blendMode = value;
		__setBlendModeCairo(cairo, value);
	}

	public function __setBlendModeCairo(cairo:Cairo, value:BlendMode):Void
	{
		switch (value)
		{
			case ADD:
				cairo.setOperator(CairoOperator.ADD);

			// case ALPHA:

			// TODO;

			case DARKEN:
				cairo.setOperator(CairoOperator.DARKEN);

			case DIFFERENCE:
				cairo.setOperator(CairoOperator.DIFFERENCE);

			// case ERASE:

			// TODO;

			case HARDLIGHT:
				cairo.setOperator(CairoOperator.HARD_LIGHT);

			// case INVERT:

			// TODO

			case LAYER:
				cairo.setOperator(CairoOperator.OVER);

			case LIGHTEN:
				cairo.setOperator(CairoOperator.LIGHTEN);

			case MULTIPLY:
				cairo.setOperator(CairoOperator.MULTIPLY);

			case OVERLAY:
				cairo.setOperator(CairoOperator.OVERLAY);

			case SCREEN:
				cairo.setOperator(CairoOperator.SCREEN);

			// case SHADER:

			// TODO

			// case SUBTRACT:

			// TODO;

			default:
				cairo.setOperator(CairoOperator.OVER);
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
				|| ((object._ : _DisplayObject).__graphics != null && (object._ : _DisplayObject).__graphics._.__softwareDirty)
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
					&& (object._ : _DisplayObject).__renderData.cacheBitmapData._.__getSurface() != null
						&& (object._ : _DisplayObject).__renderData.cacheBitmapData._.__getVersion() < (object._:_DisplayObject)
							.__renderData.cacheBitmapData._.__renderData.textureVersion)
			{
				needRender = true;
			}

			// TODO: Handle renderTransform (for scrollRect, displayMatrix changes, etc)
			var updateTransform = (needRender
				|| !((object._ : _DisplayObject).__renderData.cacheBitmap._._ : _BitmapData).__worldTransform.equals((object._ : _DisplayObject)
					.__worldTransform));

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
						((object._ : _DisplayObject).__renderData.cacheBitmap._._ : _BitmapData).__bitmapData = (object._ : _DisplayObject)
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
					ColorTransform._.__pool.release(colorTransform);

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
				((object._ : _DisplayObject).__renderData.cacheBitmap._._ : _BitmapData).__worldTransform.copyFrom((object._ : _DisplayObject)
					.__worldTransform);

				if (bitmapMatrix == (object._ : _DisplayObject).__renderTransform)
				{
					((object._ : _DisplayObject).__renderData.cacheBitmap._._ : _BitmapData).__renderTransform.identity();
					((object._ : _DisplayObject).__renderData.cacheBitmap._._ : _BitmapData).__renderTransform.tx = (object._ : _DisplayObject)
						.__renderTransform.tx + offsetX;
					((object._ : _DisplayObject).__renderData.cacheBitmap._._ : _BitmapData).__renderTransform.ty = (object._ : _DisplayObject)
						.__renderTransform.ty + offsetY;
				}
				else
				{
					((object._ : _DisplayObject).__renderData.cacheBitmap._._ : _BitmapData).__renderTransform.copyFrom((object._ : _DisplayObject)
						.__renderData.cacheBitmapMatrix);
					((object._ : _DisplayObject).__renderData.cacheBitmap._._ : _BitmapData).__renderTransform.invert();
					((object._ : _DisplayObject).__renderData.cacheBitmap._._ : _BitmapData).__renderTransform.concat((object._ : _DisplayObject)
						.__renderTransform);
					((object._ : _DisplayObject).__renderData.cacheBitmap._._ : _BitmapData).__renderTransform.tx += offsetX;
					((object._ : _DisplayObject).__renderData.cacheBitmap._._ : _BitmapData).__renderTransform.ty += offsetY;
				}
			}

				(object._ : _DisplayObject).__renderData.cacheBitmap.smoothing = __allowSmoothing;
			((object._ : _DisplayObject).__renderData.cacheBitmap._._ : _BitmapData).__renderable = (object._ : _DisplayObject).__renderable;
			((object._ : _DisplayObject).__renderData.cacheBitmap._._ : _BitmapData).__worldAlpha = (object._ : _DisplayObject).__worldAlpha;
			((object._ : _DisplayObject).__renderData.cacheBitmap._._ : _BitmapData).__worldBlendMode = (object._ : _DisplayObject).__worldBlendMode;
			((object._ : _DisplayObject).__renderData.cacheBitmap._._ : _BitmapData).__worldShader = (object._ : _DisplayObject).__worldShader;
			(object._ : _DisplayObject).__renderData.cacheBitmap.mask = (object._ : _DisplayObject).__mask;

			if (needRender)
			{
				if ((object._ : _DisplayObject).__renderData.cacheBitmapRendererSW == null
					|| ((object._ : _DisplayObject).__renderData.cacheBitmapRendererSW._ : _DisplayObjectRenderer).__type != CAIRO)
				{
					if ((object._ : _DisplayObject).__renderData.cacheBitmapData._.__getSurface() == null)
					{
						var color = object.opaqueBackground != null ? (0xFF << 24) | object.opaqueBackground : 0;
							(object._ : _DisplayObject).__renderData.cacheBitmapData = new BitmapData(bitmapWidth, bitmapHeight, true, color);
						((object._ : _DisplayObject).__renderData.cacheBitmap._._ : _BitmapData).__bitmapData = (object._ : _DisplayObject)
							.__renderData.cacheBitmapData;
					}

						(object._ : _DisplayObject).__renderData.cacheBitmapRendererSW = new CairoRenderer(new Cairo((object._ : _DisplayObject)
							.__renderData.cacheBitmapData.getSurface()));
					((object._ : _DisplayObject).__renderData.cacheBitmapRendererSW._ : _DisplayObjectRenderer).__worldTransform = new Matrix();
					((object._ : _DisplayObject).__renderData.cacheBitmapRendererSW._ : _DisplayObjectRenderer).__worldColorTransform = new ColorTransform();
				}

				if ((object._ : _DisplayObject).__renderData.cacheBitmapColorTransform == null) (object._ : _DisplayObject)
					.__renderData.cacheBitmapColorTransform = new ColorTransform();

				((object._ : _DisplayObject).__renderData.cacheBitmapRendererSW._ : _DisplayObjectRenderer).__stage = object.stage;

				((object._ : _DisplayObject).__renderData.cacheBitmapRendererSW._ : _DisplayObjectRenderer).__allowSmoothing = __allowSmoothing;
				cast((object._ : _DisplayObject).__renderData.cacheBitmapRendererSW, CairoRenderer)._.__setBlendMode(NORMAL);
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

				((object._ : _DisplayObject).__renderData.cacheBitmapRendererSW._ : _DisplayObjectRenderer).__drawBitmapData((object._ : _DisplayObject)
					.__renderData.cacheBitmapData, object, null);

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
							|| (object._ : _DisplayObject).__renderData.cacheBitmapData2._.__getSurface() == null
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
							|| (object._ : _DisplayObject).__renderData.cacheBitmapData3._.__getSurface() == null
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
						// TODO: Fix issue with swapping __renderData.cacheBitmap._.__bitmapData
						// __renderData.cacheBitmapData.copyPixels (bitmap, bitmap.rect, destPoint);

						// Adding __renderData.cacheBitmapRendererSW = null; makes this work
						cacheBitmap = (object._ : _DisplayObject).__renderData.cacheBitmapData;
						(object._ : _DisplayObject).__renderData.cacheBitmapData = bitmap;
						(object._ : _DisplayObject).__renderData.cacheBitmapData2 = cacheBitmap;
						((object._ : _DisplayObject).__renderData.cacheBitmap._._ : _BitmapData).__bitmapData = (object._ : _DisplayObject)
							.__renderData.cacheBitmapData;
						(object._ : _DisplayObject).__renderData.cacheBitmapRendererSW = null;
					}

						((object._ : _DisplayObject).__renderData.cacheBitmap._._ : _BitmapData).__imageVersion = (object._ : _DisplayObject)
							.__renderData.cacheBitmapData._.__renderData.textureVersion;
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

			ColorTransform._.__pool.release(colorTransform);
		}
		else if ((object._ : _DisplayObject).__renderData.cacheBitmap != null)
		{
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
