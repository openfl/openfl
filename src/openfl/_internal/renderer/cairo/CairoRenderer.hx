package openfl._internal.renderer.cairo;

import lime.graphics.cairo.Cairo;
import lime.graphics.cairo.CairoFilter;
import lime.graphics.cairo.CairoOperator;
import lime.graphics.cairo.CairoPattern;
import lime.math.Matrix3;
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
import openfl.geom.Point;
import openfl.geom.Rectangle;

/**
	**BETA**

	The CairoRenderer API exposes support for native Cairo render instructions within the
	`RenderEvent.RENDER_CAIRO` event
**/
#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
@:access(openfl.display.BitmapData)
@:access(openfl.display.DisplayObject)
@:access(openfl.display.Graphics)
@:access(openfl.display.IBitmapDrawable)
@:access(openfl.display.Stage)
@:access(openfl.display.Stage3D)
@:access(openfl.events.RenderEvent)
@:access(openfl.filters.BitmapFilter)
@:access(openfl.geom.ColorTransform)
@:access(openfl.geom.Matrix)
@:access(openfl.geom.Rectangle)
@:allow(openfl._internal.renderer.cairo)
@SuppressWarnings("checkstyle:FieldDocComment")
class CairoRenderer extends CairoRendererAPI
{
	private var __matrix:Matrix;
	private var __matrix3:Matrix3;
	private var __colorTransform:ColorTransform;

	private function new(cairo:Cairo)
	{
		super(cairo);

		__colorTransform = new ColorTransform();
		__matrix = new Matrix();
		__matrix3 = new Matrix3();

		__type = CAIRO;
	}

	public override function applyMatrix(transform:Matrix, cairo:Cairo = null):Void
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

	private override function __clear():Void
	{
		if (cairo == null) return;

		cairo.identityMatrix();

		if (__stage != null && __stage.__clearBeforeRender)
		{
			var cacheBlendMode = __blendMode;
			__setBlendMode(NORMAL);

			cairo.setSourceRGB(__stage.__colorSplit[0], __stage.__colorSplit[1], __stage.__colorSplit[2]);
			cairo.paint();

			__setBlendMode(cacheBlendMode);
		}
	}

	private override function __drawBitmapData(bitmapData:BitmapData, source:IBitmapDrawable, clipRect:Rectangle):Void
	{
		if (clipRect != null)
		{
			__pushMaskRect(clipRect, source.__renderTransform);
		}

		if (source == bitmapData)
		{
			source = bitmapData.clone();
		}

		if (!__allowSmoothing) cairo.antialias = NONE;

		__render(source);

		if (!__allowSmoothing) cairo.antialias = GOOD;

		cairo.target.flush();

		bitmapData.image.dirty = true;
		bitmapData.image.version++;

		if (clipRect != null)
		{
			__popMaskRect();
		}
	}

	private function __getAlpha(value:Float):Float
	{
		return value * __worldAlpha;
	}

	private function __getColorTransform(value:ColorTransform):ColorTransform
	{
		if (__worldColorTransform != null)
		{
			__colorTransform.__copyFrom(__worldColorTransform);
			__colorTransform.__combine(value);
			return __colorTransform;
		}
		else
		{
			return value;
		}
	}

	private function __popMask():Void
	{
		cairo.restore();
	}

	private function __popMaskObject(object:DisplayObject, handleScrollRect:Bool = true):Void
	{
		if (!object.__isCacheBitmapRender && object.__mask != null)
		{
			__popMask();
		}

		if (handleScrollRect && object.__scrollRect != null)
		{
			__popMaskRect();
		}
	}

	private function __popMaskRect():Void
	{
		cairo.restore();
	}

	private function __pushMask(mask:DisplayObject):Void
	{
		cairo.save();

		applyMatrix(mask.__renderTransform, cairo);

		cairo.newPath();
		__renderMask(mask);
		cairo.clip();
	}

	private function __pushMaskObject(object:DisplayObject, handleScrollRect:Bool = true):Void
	{
		if (handleScrollRect && object.__scrollRect != null)
		{
			__pushMaskRect(object.__scrollRect, object.__renderTransform);
		}

		if (!object.__isCacheBitmapRender && object.__mask != null)
		{
			__pushMask(object.__mask);
		}
	}

	private function __pushMaskRect(rect:Rectangle, transform:Matrix):Void
	{
		cairo.save();

		applyMatrix(transform, cairo);

		cairo.newPath();
		cairo.rectangle(rect.x, rect.y, rect.width, rect.height);
		cairo.clip();
	}

	private override function __render(object:IBitmapDrawable):Void
	{
		if (cairo == null) return;

		if (object != null)
		{
			if (object.__type != null)
			{
				__renderDisplayObject(cast object);
			}
			else
			{
				__renderBitmapData(cast object);
			}
		}
	}

	private function __renderBitmap(bitmap:Bitmap):Void
	{
		__updateCacheBitmap(bitmap, /*!__worldColorTransform.__isDefault ()*/ false);

		if (bitmap.__bitmapData != null && bitmap.__bitmapData.image != null)
		{
			bitmap.__imageVersion = bitmap.__bitmapData.image.version;
		}

		if (bitmap.__cacheBitmap != null && !bitmap.__isCacheBitmapRender)
		{
			CairoBitmap.render(bitmap.__cacheBitmap, this);
		}
		else
		{
			CairoDisplayObject.render(bitmap, this);
			CairoBitmap.render(bitmap, this);
		}
	}

	private function __renderBitmapData(bitmapData:BitmapData):Void
	{
		if (!bitmapData.readable) return;

		applyMatrix(bitmapData.__renderTransform, cairo);

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

	private function __renderDisplayObject(object:DisplayObject):Void
	{
		if (object != null && object.__type != null)
		{
			switch (object.__type)
			{
				case BITMAP:
					__renderBitmap(cast object);
				case DISPLAY_OBJECT_CONTAINER:
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

			if (object.__customRenderEvent != null)
			{
				var event = object.__customRenderEvent;
				event.allowSmoothing = __allowSmoothing;
				event.objectMatrix.copyFrom(object.__renderTransform);
				event.objectColorTransform.__copyFrom(object.__worldColorTransform);
				event.renderer = this;
				event.type = RenderEvent.RENDER_CAIRO;

				__setBlendMode(object.__worldBlendMode);
				__pushMaskObject(object);

				object.dispatchEvent(event);

				__popMaskObject(object);
			}
		}
	}

	private function __renderDisplayObjectContainer(container:DisplayObjectContainer):Void
	{
		container.__cleanupRemovedChildren();

		if (!container.__renderable || container.__worldAlpha <= 0) return;

		__updateCacheBitmap(container, /*!__worldColorTransform.__isDefault ()*/ false);

		if (container.__cacheBitmap != null && !container.__isCacheBitmapRender)
		{
			CairoBitmap.render(container.__cacheBitmap, this);
		}
		else
		{
			CairoDisplayObject.render(container, this);
		}

		if (container.__cacheBitmap != null && !container.__isCacheBitmapRender) return;

		__pushMaskObject(container);

		if (__stage != null)
		{
			for (child in container.__children)
			{
				__renderDisplayObject(child);
				child.__renderDirty = false;
			}

			container.__renderDirty = false;
		}
		else
		{
			for (child in container.__children)
			{
				__renderDisplayObject(child);
			}
		}

		__popMaskObject(container);
	}

	private function __renderMask(mask:DisplayObject):Void
	{
		if (mask != null)
		{
			switch (mask.__type)
			{
				case BITMAP:
					cairo.rectangle(0, 0, mask.width, mask.height);

				case DISPLAY_OBJECT_CONTAINER:
					var container:DisplayObjectContainer = cast mask;
					container.__cleanupRemovedChildren();

					if (container.__graphics != null)
					{
						CairoGraphics.renderMask(container.__graphics, this);
					}

					for (child in container.__children)
					{
						__renderMask(child);
					}

				case DOM_ELEMENT:

				case SIMPLE_BUTTON:
					var button:SimpleButton = cast mask;
					__renderMask(button.__currentState);

				default:
					if (mask.__graphics != null)
					{
						CairoGraphics.renderMask(mask.__graphics, this);
					}
			}
		}
	}

	private function __renderShape(shape:DisplayObject):Void
	{
		__updateCacheBitmap(shape, /*!__worldColorTransform.__isDefault ()*/ false);

		if (shape.__cacheBitmap != null && !shape.__isCacheBitmapRender)
		{
			CairoBitmap.render(shape.__cacheBitmap, this);
		}
		else
		{
			CairoDisplayObject.render(shape, this);
		}
	}

	private function __renderSimpleButton(button:SimpleButton):Void
	{
		if (!button.__renderable || button.__worldAlpha <= 0 || button.__currentState == null) return;

		__pushMaskObject(button);
		__renderDisplayObject(button.__currentState);
		__popMaskObject(button);
	}

	private function __renderTextField(textField:TextField):Void
	{
		__updateCacheBitmap(textField, /*!__worldColorTransform.__isDefault ()*/ false);

		if (textField.__cacheBitmap != null && !textField.__isCacheBitmapRender)
		{
			CairoBitmap.render(textField.__cacheBitmap, this);
		}
		else
		{
			CairoTextField.render(textField, this, textField.__worldTransform);
			CairoDisplayObject.render(textField, this);
		}
	}

	private function __renderTilemap(tilemap:Tilemap):Void
	{
		__updateCacheBitmap(tilemap, /*!__worldColorTransform.__isDefault ()*/ false);

		if (tilemap.__cacheBitmap != null && !tilemap.__isCacheBitmapRender)
		{
			CairoBitmap.render(tilemap.__cacheBitmap, this);
		}
		else
		{
			CairoDisplayObject.render(tilemap, this);
			CairoTilemap.render(tilemap, this);
		}
	}

	private function __renderVideo(video:Video):Void
	{
		// CanvasVideo.render(video, this);
	}

	private function __setBlendMode(value:BlendMode):Void
	{
		if (__overrideBlendMode != null) value = __overrideBlendMode;
		if (__blendMode == value) return;

		__blendMode = value;
		__setBlendModeCairo(cairo, value);
	}

	private function __setBlendModeCairo(cairo:Cairo, value:BlendMode):Void
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

	private function __updateCacheBitmap(object:DisplayObject, force:Bool):Bool
	{
		#if openfl_disable_cacheasbitmap
		return false;
		#end

		if (object.__isCacheBitmapRender) return false;
		var updated = false;

		if (object.cacheAsBitmap
			|| !object.__worldColorTransform.__isDefault(true)
			|| (__worldColorTransform != null && !__worldColorTransform.__isDefault(true)))
		{
			if (object.__cacheBitmapMatrix == null)
			{
				object.__cacheBitmapMatrix = new Matrix();
			}

			var hasFilters = #if !openfl_disable_filters object.__filters != null #else false #end;
			var bitmapMatrix = (object.__cacheAsBitmapMatrix != null ? object.__cacheAsBitmapMatrix : object.__renderTransform);

			var rect = null;

			var colorTransform = ColorTransform.__pool.get();
			colorTransform.__copyFrom(object.__worldColorTransform);
			if (__worldColorTransform != null) colorTransform.__combine(__worldColorTransform);

			var needRender = (object.__cacheBitmap == null
				|| (object.__renderDirty && (force || (object.__children != null && object.__children.length > 0)))
				|| object.opaqueBackground != object.__cacheBitmapBackground)
				|| (object.__graphics != null && object.__graphics.__softwareDirty)
				|| !object.__cacheBitmapColorTransform.__equals(colorTransform, true);

			if (!needRender
				&& (bitmapMatrix.a != object.__cacheBitmapMatrix.a
					|| bitmapMatrix.b != object.__cacheBitmapMatrix.b
					|| bitmapMatrix.c != object.__cacheBitmapMatrix.c
					|| bitmapMatrix.d != object.__cacheBitmapMatrix.d))
			{
				needRender = true;
			}

			if (hasFilters && !needRender)
			{
				for (filter in object.__filters)
				{
					if (filter.__renderDirty)
					{
						needRender = true;
						break;
					}
				}
			}

			if (!needRender
				&& object.__cacheBitmapData != null
				&& object.__cacheBitmapData.image != null
				&& object.__cacheBitmapData.image.version < object.__cacheBitmapData.__textureVersion)
			{
				needRender = true;
			}

			// TODO: Handle renderTransform (for scrollRect, displayMatrix changes, etc)
			var updateTransform = (needRender || !object.__cacheBitmap.__worldTransform.equals(object.__worldTransform));

			object.__cacheBitmapMatrix.copyFrom(bitmapMatrix);
			object.__cacheBitmapMatrix.tx = 0;
			object.__cacheBitmapMatrix.ty = 0;

			// TODO: Handle dimensions better if object has a scrollRect?

			var bitmapWidth = 0, bitmapHeight = 0;
			var filterWidth = 0, filterHeight = 0;
			var offsetX = 0., offsetY = 0.;

			if (updateTransform)
			{
				rect = Rectangle.__pool.get();

				object.__getFilterBounds(rect, object.__cacheBitmapMatrix);

				filterWidth = Math.ceil(rect.width);
				filterHeight = Math.ceil(rect.height);

				offsetX = rect.x > 0 ? Math.ceil(rect.x) : Math.floor(rect.x);
				offsetY = rect.y > 0 ? Math.ceil(rect.y) : Math.floor(rect.y);

				if (object.__cacheBitmapData != null)
				{
					if (filterWidth > object.__cacheBitmapData.width || filterHeight > object.__cacheBitmapData.height)
					{
						bitmapWidth = Math.ceil(Math.max(filterWidth * 1.25, object.__cacheBitmapData.width));
						bitmapHeight = Math.ceil(Math.max(filterHeight * 1.25, object.__cacheBitmapData.height));
						needRender = true;
					}
					else
					{
						bitmapWidth = object.__cacheBitmapData.width;
						bitmapHeight = object.__cacheBitmapData.height;
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
				object.__cacheBitmapBackground = object.opaqueBackground;

				if (filterWidth >= 0.5 && filterHeight >= 0.5)
				{
					var needsFill = (object.opaqueBackground != null && (bitmapWidth != filterWidth || bitmapHeight != filterHeight));
					var fillColor = object.opaqueBackground != null ? (0xFF << 24) | object.opaqueBackground : 0;
					var bitmapColor = needsFill ? 0 : fillColor;

					if (object.__cacheBitmapData == null
						|| bitmapWidth > object.__cacheBitmapData.width
						|| bitmapHeight > object.__cacheBitmapData.height)
					{
						object.__cacheBitmapData = new BitmapData(bitmapWidth, bitmapHeight, true, bitmapColor);

						if (object.__cacheBitmap == null) object.__cacheBitmap = new Bitmap();
						object.__cacheBitmap.__bitmapData = object.__cacheBitmapData;
						object.__cacheBitmapRendererSW = null;
					}
					else
					{
						object.__cacheBitmapData.fillRect(object.__cacheBitmapData.rect, bitmapColor);
					}

					if (needsFill)
					{
						rect.setTo(0, 0, filterWidth, filterHeight);
						object.__cacheBitmapData.fillRect(rect, fillColor);
					}
				}
				else
				{
					ColorTransform.__pool.release(colorTransform);

					object.__cacheBitmap = null;
					object.__cacheBitmapData = null;
					object.__cacheBitmapData2 = null;
					object.__cacheBitmapData3 = null;
					object.__cacheBitmapRendererSW = null;

					return true;
				}
			}
			else
			{
				// Should we retain these longer?

				object.__cacheBitmapData = object.__cacheBitmap.bitmapData;
				object.__cacheBitmapData2 = null;
				object.__cacheBitmapData3 = null;
			}

			if (updateTransform)
			{
				object.__cacheBitmap.__worldTransform.copyFrom(object.__worldTransform);

				if (bitmapMatrix == object.__renderTransform)
				{
					object.__cacheBitmap.__renderTransform.identity();
					object.__cacheBitmap.__renderTransform.tx = object.__renderTransform.tx + offsetX;
					object.__cacheBitmap.__renderTransform.ty = object.__renderTransform.ty + offsetY;
				}
				else
				{
					object.__cacheBitmap.__renderTransform.copyFrom(object.__cacheBitmapMatrix);
					object.__cacheBitmap.__renderTransform.invert();
					object.__cacheBitmap.__renderTransform.concat(object.__renderTransform);
					object.__cacheBitmap.__renderTransform.tx += offsetX;
					object.__cacheBitmap.__renderTransform.ty += offsetY;
				}
			}

			object.__cacheBitmap.smoothing = __allowSmoothing;
			object.__cacheBitmap.__renderable = object.__renderable;
			object.__cacheBitmap.__worldAlpha = object.__worldAlpha;
			object.__cacheBitmap.__worldBlendMode = object.__worldBlendMode;
			object.__cacheBitmap.__worldShader = object.__worldShader;
			object.__cacheBitmap.mask = object.__mask;

			if (needRender)
			{
				if (object.__cacheBitmapRendererSW == null || object.__cacheBitmapRendererSW.__type != CAIRO)
				{
					if (object.__cacheBitmapData.image == null)
					{
						var color = object.opaqueBackground != null ? (0xFF << 24) | object.opaqueBackground : 0;
						object.__cacheBitmapData = new BitmapData(bitmapWidth, bitmapHeight, true, color);
						object.__cacheBitmap.__bitmapData = object.__cacheBitmapData;
					}

					object.__cacheBitmapRendererSW = new CairoRenderer(new Cairo(object.__cacheBitmapData.getSurface()));
					object.__cacheBitmapRendererSW.__worldTransform = new Matrix();
					object.__cacheBitmapRendererSW.__worldColorTransform = new ColorTransform();
				}

				if (object.__cacheBitmapColorTransform == null) object.__cacheBitmapColorTransform = new ColorTransform();

				object.__cacheBitmapRendererSW.__stage = object.stage;

				object.__cacheBitmapRendererSW.__allowSmoothing = __allowSmoothing;
				cast(object.__cacheBitmapRendererSW, CairoRenderer).__setBlendMode(NORMAL);
				object.__cacheBitmapRendererSW.__worldAlpha = 1 / object.__worldAlpha;

				object.__cacheBitmapRendererSW.__worldTransform.copyFrom(object.__renderTransform);
				object.__cacheBitmapRendererSW.__worldTransform.invert();
				object.__cacheBitmapRendererSW.__worldTransform.concat(object.__cacheBitmapMatrix);
				object.__cacheBitmapRendererSW.__worldTransform.tx -= offsetX;
				object.__cacheBitmapRendererSW.__worldTransform.ty -= offsetY;

				object.__cacheBitmapRendererSW.__worldColorTransform.__copyFrom(colorTransform);
				object.__cacheBitmapRendererSW.__worldColorTransform.__invert();

				object.__isCacheBitmapRender = true;

				object.__cacheBitmapRendererSW.__drawBitmapData(object.__cacheBitmapData, object, null);

				if (hasFilters)
				{
					var needSecondBitmapData = false;
					var needCopyOfOriginal = false;

					for (filter in object.__filters)
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

					var bitmap = object.__cacheBitmapData;
					var bitmap2 = null;
					var bitmap3 = null;

					if (needSecondBitmapData)
					{
						if (object.__cacheBitmapData2 == null
							|| object.__cacheBitmapData2.image == null
							|| bitmapWidth > object.__cacheBitmapData2.width
							|| bitmapHeight > object.__cacheBitmapData2.height)
						{
							object.__cacheBitmapData2 = new BitmapData(bitmapWidth, bitmapHeight, true, 0);
						}
						else
						{
							object.__cacheBitmapData2.fillRect(object.__cacheBitmapData2.rect, 0);
						}
						bitmap2 = object.__cacheBitmapData2;
					}
					else
					{
						bitmap2 = bitmap;
					}

					if (needCopyOfOriginal)
					{
						if (object.__cacheBitmapData3 == null
							|| object.__cacheBitmapData3.image == null
							|| bitmapWidth > object.__cacheBitmapData3.width
							|| bitmapHeight > object.__cacheBitmapData3.height)
						{
							object.__cacheBitmapData3 = new BitmapData(bitmapWidth, bitmapHeight, true, 0);
						}
						else
						{
							object.__cacheBitmapData3.fillRect(object.__cacheBitmapData3.rect, 0);
						}
						bitmap3 = object.__cacheBitmapData3;
					}

					if (object.__tempPoint == null) object.__tempPoint = new Point();
					var destPoint = object.__tempPoint;
					var cacheBitmap, lastBitmap;

					for (filter in object.__filters)
					{
						if (filter.__preserveObject)
						{
							bitmap3.copyPixels(bitmap, bitmap.rect, destPoint);
						}

						lastBitmap = filter.__applyFilter(bitmap2, bitmap, bitmap.rect, destPoint);

						if (filter.__preserveObject)
						{
							lastBitmap.draw(bitmap3, null, object.__objectTransform != null ? object.__objectTransform.colorTransform : null);
						}
						filter.__renderDirty = false;

						if (needSecondBitmapData && lastBitmap == bitmap2)
						{
							cacheBitmap = bitmap;
							bitmap = bitmap2;
							bitmap2 = cacheBitmap;
						}
					}

					if (object.__cacheBitmapData != bitmap)
					{
						// TODO: Fix issue with swapping __cacheBitmap.__bitmapData
						// __cacheBitmapData.copyPixels (bitmap, bitmap.rect, destPoint);

						// Adding __cacheBitmapRendererSW = null; makes this work
						cacheBitmap = object.__cacheBitmapData;
						object.__cacheBitmapData = bitmap;
						object.__cacheBitmapData2 = cacheBitmap;
						object.__cacheBitmap.__bitmapData = object.__cacheBitmapData;
						object.__cacheBitmapRendererSW = null;
					}

					object.__cacheBitmap.__imageVersion = object.__cacheBitmapData.__textureVersion;
				}

				object.__cacheBitmapColorTransform.__copyFrom(colorTransform);

				if (!object.__cacheBitmapColorTransform.__isDefault(true))
				{
					object.__cacheBitmapColorTransform.alphaMultiplier = 1;
					object.__cacheBitmapData.colorTransform(object.__cacheBitmapData.rect, object.__cacheBitmapColorTransform);
				}

				object.__isCacheBitmapRender = false;
			}

			if (updateTransform)
			{
				Rectangle.__pool.release(rect);
			}

			updated = updateTransform;

			ColorTransform.__pool.release(colorTransform);
		}
		else if (object.__cacheBitmap != null)
		{
			object.__cacheBitmap = null;
			object.__cacheBitmapData = null;
			object.__cacheBitmapData2 = null;
			object.__cacheBitmapData3 = null;
			object.__cacheBitmapColorTransform = null;
			object.__cacheBitmapRendererSW = null;

			updated = true;
		}

		return updated;
	}
}
