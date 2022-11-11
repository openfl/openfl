package openfl.display;

#if !flash
import openfl.display._internal.CairoBitmap;
import openfl.display._internal.CairoBitmapData;
import openfl.display._internal.CairoDisplayObject;
import openfl.display._internal.CairoDisplayObjectContainer;
import openfl.display._internal.CairoGraphics;
import openfl.display._internal.CairoShape;
import openfl.display._internal.CairoSimpleButton;
import openfl.display._internal.CairoTextField;
import openfl.display._internal.CairoTilemap;
import openfl.geom.Matrix;
import openfl.geom.Rectangle;
#if lime
import lime.graphics.cairo.Cairo;
import lime.graphics.cairo.CairoOperator;
import lime.graphics.CairoRenderContext;
import lime.math.Matrix3;
#end

/**
	**BETA**

	The CairoRenderer API exposes support for native Cairo render instructions within the
	`RenderEvent.RENDER_CAIRO` event
**/
#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
@:access(openfl.display.DisplayObject)
@:access(openfl.display.Graphics)
@:access(openfl.display.IBitmapDrawable)
@:access(openfl.display.Stage)
@:access(openfl.display.Stage3D)
@:allow(openfl.display._internal)
@:allow(openfl.display)
class CairoRenderer extends DisplayObjectRenderer
{
	/**
		The current Cairo render context
	**/
	@SuppressWarnings("checkstyle:Dynamic")
	public var cairo:#if lime CairoRenderContext #else Dynamic #end;

	@:noCompletion private var __matrix:Matrix;
	@SuppressWarnings("checkstyle:Dynamic") @:noCompletion private var __matrix3:#if lime Matrix3 #else Dynamic #end;

	@SuppressWarnings("checkstyle:Dynamic")
	@:noCompletion private function new(cairo:#if lime Cairo #else Dynamic #end)
	{
		super();

		#if lime_cairo
		this.cairo = cairo;

		__matrix = new Matrix();
		__matrix3 = new Matrix3();

		__type = CAIRO;
		#end
	}

	/**
		Set the matrix value for the current render context, or (optionally) another Cairo
		object
	**/
	@SuppressWarnings("checkstyle:Dynamic")
	public function applyMatrix(transform:Matrix, cairo:#if lime Cairo #else Dynamic #end = null):Void
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

	@:noCompletion private override function __clear():Void
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

	@:noCompletion private override function __popMask():Void
	{
		cairo.restore();
	}

	@:noCompletion private override function __popMaskObject(object:DisplayObject, handleScrollRect:Bool = true):Void
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

	@:noCompletion private override function __popMaskRect():Void
	{
		cairo.restore();
	}

	@:noCompletion private override function __pushMask(mask:DisplayObject):Void
	{
		cairo.save();

		applyMatrix(mask.__renderTransform, cairo);

		cairo.newPath();
		__renderDrawableMask(mask);
		cairo.clip();
	}

	@:noCompletion private override function __pushMaskObject(object:DisplayObject, handleScrollRect:Bool = true):Void
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

	@:noCompletion private override function __pushMaskRect(rect:Rectangle, transform:Matrix):Void
	{
		cairo.save();

		applyMatrix(transform, cairo);

		cairo.newPath();
		cairo.rectangle(rect.x, rect.y, rect.width, rect.height);
		cairo.clip();
	}

	@:noCompletion private override function __render(object:IBitmapDrawable):Void
	{
		if (cairo == null) return;

		__renderDrawable(object);
	}

	@:noCompletion private function __renderDrawable(object:IBitmapDrawable):Void
	{
		if (object == null) return;

		switch (object.__drawableType)
		{
			case BITMAP_DATA:
				CairoBitmapData.renderDrawable(cast object, this);
			case STAGE, SPRITE:
				CairoDisplayObjectContainer.renderDrawable(cast object, this);
			case BITMAP:
				CairoBitmap.renderDrawable(cast object, this);
			case SHAPE:
				CairoDisplayObject.renderDrawable(cast object, this);
			case SIMPLE_BUTTON:
				CairoSimpleButton.renderDrawable(cast object, this);
			case TEXT_FIELD:
				CairoTextField.renderDrawable(cast object, this);
			case VIDEO:
			// TODO
			case TILEMAP:
				CairoTilemap.renderDrawable(cast object, this);
			default:
		}
	}

	@:noCompletion private function __renderDrawableMask(object:IBitmapDrawable):Void
	{
		if (object == null) return;

		switch (object.__drawableType)
		{
			case BITMAP_DATA:
				CairoBitmapData.renderDrawableMask(cast object, this);
			case STAGE, SPRITE:
				CairoDisplayObjectContainer.renderDrawableMask(cast object, this);
			case BITMAP:
				CairoBitmap.renderDrawableMask(cast object, this);
			case SHAPE:
				CairoShape.renderDrawableMask(cast object, this);
			case SIMPLE_BUTTON:
				CairoSimpleButton.renderDrawableMask(cast object, this);
			case TEXT_FIELD:
				CairoTextField.renderDrawableMask(cast object, this);
			case VIDEO:
			// TODO
			case TILEMAP:
				CairoTilemap.renderDrawableMask(cast object, this);
			default:
		}
	}

	@:noCompletion private override function __setBlendMode(value:BlendMode):Void
	{
		if (__overrideBlendMode != null) value = __overrideBlendMode;
		if (__blendMode == value) return;

		__blendMode = value;
		__setBlendModeCairo(cairo, value);
	}

	@SuppressWarnings("checkstyle:Dynamic")
	@:noCompletion private function __setBlendModeCairo(cairo:#if lime Cairo #else Dynamic #end, value:BlendMode):Void
	{
		#if lime
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
		#end
	}
}
#else
typedef CairoRenderer = Dynamic;
#end
