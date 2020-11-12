package openfl.display;

#if !flash
import openfl.display._internal.CanvasBitmap;
import openfl.display._internal.CanvasBitmapData;
import openfl.display._internal.CanvasDisplayObject;
import openfl.display._internal.CanvasDisplayObjectContainer;
import openfl.display._internal.CanvasSimpleButton;
import openfl.display._internal.CanvasTextField;
import openfl.display._internal.CanvasTilemap;
import openfl.display._internal.CanvasVideo;
import openfl.geom.Matrix;
import openfl.geom.Rectangle;
#if lime
import lime.graphics.Canvas2DRenderContext;
#end

/**
	**BETA**

	The CanvasRenderer API exposes support for HTML5 canvas render instructions within the
	`RenderEvent.RENDER_CANVAS` event
**/
#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
@:access(openfl.display.DisplayObject)
@:access(openfl.display.IBitmapDrawable)
@:access(openfl.display.Stage)
@:access(openfl.display.Stage3D)
@:allow(openfl.display._internal)
@:allow(openfl.display)
@:allow(openfl.text)
class CanvasRenderer extends DisplayObjectRenderer
{
	/**
		The current HTML5 canvas render context
	**/
	@SuppressWarnings("checkstyle:Dynamic")
	public var context:#if lime Canvas2DRenderContext #else Dynamic #end;

	/**
		The active pixel ratio used during rendering
	**/
	public var pixelRatio(default, null):Float = 1;

	@:noCompletion private var __isDOM:Bool;
	@:noCompletion private var __tempMatrix:Matrix;

	@SuppressWarnings("checkstyle:Dynamic")
	@:noCompletion private function new(context:#if lime Canvas2DRenderContext #else Dynamic #end)
	{
		super();

		this.context = context;

		__tempMatrix = new Matrix();

		#if lime
		__type = CANVAS;
		#end
	}

	/**
		Set whether smoothing should be enabled on a canvas context
	**/
	@SuppressWarnings("checkstyle:Dynamic")
	public function applySmoothing(context:#if lime Canvas2DRenderContext #else Dynamic #end, value:Bool):Void
	{
		context.imageSmoothingEnabled = value;
	}

	/**
		Set the matrix value for the current render context, or (optionally) another canvas
		context
	**/
	@SuppressWarnings("checkstyle:Dynamic")
	public function setTransform(transform:Matrix, context:#if lime Canvas2DRenderContext #else Dynamic #end = null):Void
	{
		if (context == null)
		{
			context = this.context;
		}
		else if (this.context == context && __worldTransform != null)
		{
			__tempMatrix.copyFrom(transform);
			__tempMatrix.concat(__worldTransform);
			transform = __tempMatrix;
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

	@:noCompletion private override function __clear():Void
	{
		if (__stage != null)
		{
			var cacheBlendMode = __blendMode;
			__blendMode = null;
			__setBlendMode(NORMAL);

			context.setTransform(1, 0, 0, 1, 0, 0);
			context.globalAlpha = 1;

			if (!__stage.__transparent && __stage.__clearBeforeRender)
			{
				context.fillStyle = __stage.__colorString;
				context.fillRect(0, 0, __stage.stageWidth * __stage.window.scale, __stage.stageHeight * __stage.window.scale);
			}
			else if (__stage.__transparent && __stage.__clearBeforeRender)
			{
				context.clearRect(0, 0, __stage.stageWidth * __stage.window.scale, __stage.stageHeight * __stage.window.scale);
			}

			__setBlendMode(cacheBlendMode);
		}
	}

	@:noCompletion private override function __popMask():Void
	{
		context.restore();
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
		context.restore();
	}

	@:noCompletion private override function __pushMask(mask:DisplayObject):Void
	{
		context.save();

		setTransform(mask.__renderTransform, context);

		context.beginPath();
		__renderDrawableMask(mask);
		context.closePath();

		context.clip();
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
		context.save();

		setTransform(transform, context);

		context.beginPath();
		context.rect(rect.x, rect.y, rect.width, rect.height);
		context.clip();
	}

	@:noCompletion private override function __render(object:IBitmapDrawable):Void
	{
		__renderDrawable(object);
	}

	@:noCompletion private function __renderDrawable(object:IBitmapDrawable):Void
	{
		if (object == null) return;

		switch (object.__drawableType)
		{
			case BITMAP_DATA:
				CanvasBitmapData.renderDrawable(cast object, this);
			case STAGE, SPRITE:
				CanvasDisplayObjectContainer.renderDrawable(cast object, this);
			case BITMAP:
				CanvasBitmap.renderDrawable(cast object, this);
			case SHAPE:
				CanvasDisplayObject.renderDrawable(cast object, this);
			case SIMPLE_BUTTON:
				CanvasSimpleButton.renderDrawable(cast object, this);
			case TEXT_FIELD:
				CanvasTextField.renderDrawable(cast object, this);
			case VIDEO:
				CanvasVideo.renderDrawable(cast object, this);
			case TILEMAP:
				CanvasTilemap.renderDrawable(cast object, this);
			default:
		}
	}

	@:noCompletion private function __renderDrawableMask(object:IBitmapDrawable):Void
	{
		if (object == null) return;

		switch (object.__drawableType)
		{
			case BITMAP_DATA:
				CanvasBitmapData.renderDrawableMask(cast object, this);
			case STAGE, SPRITE:
				CanvasDisplayObjectContainer.renderDrawableMask(cast object, this);
			case BITMAP:
				CanvasBitmap.renderDrawableMask(cast object, this);
			case SHAPE:
				CanvasDisplayObject.renderDrawableMask(cast object, this);
			case SIMPLE_BUTTON:
				CanvasSimpleButton.renderDrawableMask(cast object, this);
			case TEXT_FIELD:
				CanvasTextField.renderDrawableMask(cast object, this);
			case VIDEO:
				CanvasVideo.renderDrawableMask(cast object, this);
			case TILEMAP:
				CanvasTilemap.renderDrawableMask(cast object, this);
			default:
		}
	}

	@:noCompletion private override function __setBlendMode(value:BlendMode):Void
	{
		if (__overrideBlendMode != null) value = __overrideBlendMode;
		if (__blendMode == value) return;

		__blendMode = value;
		__setBlendModeContext(context, value);
	}

	@SuppressWarnings("checkstyle:Dynamic")
	@:noCompletion private function __setBlendModeContext(context:#if lime Canvas2DRenderContext #else Dynamic #end, value:BlendMode):Void
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
}
#else
typedef CanvasRenderer = Dynamic;
#end
