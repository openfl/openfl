package openfl.display;

#if !flash
import openfl.display._internal.DOMBitmap;
// import openfl.display._internal.DOMBitmapData;
import openfl.display._internal.DOMDisplayObject;
import openfl.display._internal.DOMDisplayObjectContainer;
import openfl.display._internal.DOMSimpleButton;
import openfl.display._internal.DOMTextField;
import openfl.display._internal.DOMTilemap;
import openfl.display._internal.DOMVideo;
import openfl.geom.Matrix;
import openfl.geom.Rectangle;
#if lime
import lime.graphics.DOMRenderContext;
#end
#if (js && html5)
import js.html.Element;
#end

/**
	**BETA**

	The DOMRenderer API exposes support for HTML5 DOM render instructions within the
	`RenderEvent.RENDER_DOM` event
**/
#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
@:access(openfl.display.DisplayObject)
@:access(openfl.display.IBitmapDrawable)
@:access(openfl.display.Stage3D)
@:access(openfl.geom.Matrix)
@:access(openfl.geom.Rectangle)
@:allow(openfl.display._internal)
@:allow(openfl.display)
class DOMRenderer extends DisplayObjectRenderer
{
	/**
		The current HTML5 DOM element
	**/
	@SuppressWarnings("checkstyle:Dynamic")
	public var element:#if lime DOMRenderContext #else Dynamic #end;

	/**
		The active pixel ratio used during rendering
	**/
	public var pixelRatio(default, null):Float = 1;

	@:noCompletion private var __canvasRenderer:CanvasRenderer;
	@:noCompletion private var __clipRects:Array<Rectangle>;
	@:noCompletion private var __currentClipRect:Rectangle;
	@:noCompletion private var __numClipRects:Int;
	@:noCompletion private var __transformOriginProperty:String;
	@:noCompletion private var __transformProperty:String;
	@:noCompletion private var __vendorPrefix:String;
	@:noCompletion private var __z:Int;

	@SuppressWarnings("checkstyle:Dynamic")
	@:noCompletion private function new(element:#if lime DOMRenderContext #else Dynamic #end)
	{
		super();

		this.element = element;

		#if (js && html5)
		DisplayObject.__supportDOM = true;

		var prefix = untyped #if haxe4 js.Syntax.code #else __js__ #end ("(function () {
		  var styles = window.getComputedStyle(document.documentElement, ''),
			pre = (Array.prototype.slice
			  .call(styles)
			  .join('')
			  .match(/-(moz|webkit|ms)-/) || (styles.OLink === '' && ['', 'o'])
			)[1],
			dom = ('WebKit|Moz|MS|O').match(new RegExp('(' + pre + ')', 'i'))[1];
		  return {
			dom: dom,
			lowercase: pre,
			css: '-' + pre + '-',
			js: pre[0].toUpperCase() + pre.substr(1)
		  };
		})")();

		__vendorPrefix = prefix.lowercase;
		__transformProperty = (prefix.lowercase == "webkit") ? "-webkit-transform" : "transform";
		__transformOriginProperty = (prefix.lowercase == "webkit") ? "-webkit-transform-origin" : "transform-origin";
		#end

		__clipRects = new Array();
		__numClipRects = 0;
		__z = 0;

		#if lime
		__type = DOM;
		#end

		__canvasRenderer = new CanvasRenderer(null);
		__canvasRenderer.__isDOM = true;
	}

	/**
		Applies CSS styles to the specified DOM element, using a DisplayObject as the
		virtual parent. This helps set the z-order, position and other components for
		the DOM object
	**/
	@SuppressWarnings("checkstyle:Dynamic")
	public function applyStyle(parent:DisplayObject, childElement:#if (js && html5 && !display) Element #else Dynamic #end):Void
	{
		#if (js && html5)
		if (parent != null && childElement != null)
		{
			if (parent.__style == null || childElement.parentElement != element)
			{
				__initializeElement(parent, childElement);
			}

			parent.__style = childElement.style;

			__updateClip(parent);
			__applyStyle(parent, true, true, true);
		}
		#end
	}

	/**
		Removes previously set CSS styles from a DOM element, used when the element
		should no longer be a part of the display hierarchy
	**/
	@SuppressWarnings("checkstyle:Dynamic")
	public function clearStyle(childElement:#if (js && html5 && !display) Element #else Dynamic #end):Void
	{
		#if (js && html5)
		if (childElement != null && childElement.parentElement == element)
		{
			element.removeChild(childElement);
		}
		#end
	}

	@:noCompletion private function __applyStyle(displayObject:DisplayObject, setTransform:Bool, setAlpha:Bool, setClip:Bool):Void
	{
		#if (js && html5)
		var style = displayObject.__style;

		// TODO: displayMatrix

		if (setTransform && displayObject.__renderTransformChanged)
		{
			style.setProperty(__transformProperty, displayObject.__renderTransform.to3DString(__roundPixels), null);
		}

		if (displayObject.__worldZ != ++__z)
		{
			displayObject.__worldZ = __z;
			style.setProperty("z-index", Std.string(displayObject.__worldZ), null);
		}

		if (setAlpha && displayObject.__worldAlphaChanged)
		{
			if (displayObject.__worldAlpha < 1)
			{
				style.setProperty("opacity", Std.string(displayObject.__worldAlpha), null);
			}
			else
			{
				style.removeProperty("opacity");
			}
		}

		if (setClip && displayObject.__worldClipChanged)
		{
			if (displayObject.__worldClip == null)
			{
				style.removeProperty("clip");
			}
			else
			{
				var clip = displayObject.__worldClip;
				style.setProperty("clip", "rect(" + clip.y + "px, " + clip.right + "px, " + clip.bottom + "px, " + clip.x + "px)", null);
			}
		}
		#end
	}

	#if (js && html5)
	@:noCompletion private function __initializeElement(displayObject:DisplayObject, element:Element):Void
	{
		var style = displayObject.__style = element.style;

		style.setProperty("position", "absolute", null);
		style.setProperty("top", "0", null);
		style.setProperty("left", "0", null);
		style.setProperty(__transformOriginProperty, "0 0 0", null);

		this.element.appendChild(element);

		displayObject.__worldAlphaChanged = true;
		displayObject.__renderTransformChanged = true;
		displayObject.__worldVisibleChanged = true;
		displayObject.__worldClipChanged = true;
		displayObject.__worldClip = null;
		displayObject.__worldZ = -1;
	}
	#end

	@:noCompletion private override function __popMask():Void
	{
		__popMaskRect();
	}

	@:noCompletion private override function __popMaskObject(object:DisplayObject, handleScrollRect:Bool = true):Void
	{
		if (object.__mask != null)
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
		if (__numClipRects > 0)
		{
			__numClipRects--;

			if (__numClipRects > 0)
			{
				__currentClipRect = __clipRects[__numClipRects - 1];
			}
			else
			{
				__currentClipRect = null;
			}
		}
	}

	@:noCompletion private override function __pushMask(mask:DisplayObject):Void
	{
		// TODO: Handle true mask shape, as well as alpha test

		__pushMaskRect(mask.getBounds(mask), mask.__renderTransform);
	}

	@:noCompletion private override function __pushMaskObject(object:DisplayObject, handleScrollRect:Bool = true):Void
	{
		if (handleScrollRect && object.__scrollRect != null)
		{
			__pushMaskRect(object.__scrollRect, object.__renderTransform);
		}

		if (object.__mask != null)
		{
			__pushMask(object.__mask);
		}
	}

	@:noCompletion private override function __pushMaskRect(rect:Rectangle, transform:Matrix):Void
	{
		// TODO: Handle rotation?

		if (__numClipRects == __clipRects.length)
		{
			__clipRects[__numClipRects] = new Rectangle();
		}

		var clipRect = __clipRects[__numClipRects];
		rect.__transform(clipRect, transform);

		if (__numClipRects > 0)
		{
			var parentClipRect = __clipRects[__numClipRects - 1];
			clipRect.__contract(parentClipRect.x, parentClipRect.y, parentClipRect.width, parentClipRect.height);
		}

		if (clipRect.height < 0)
		{
			clipRect.height = 0;
		}

		if (clipRect.width < 0)
		{
			clipRect.width = 0;
		}

		__currentClipRect = clipRect;
		__numClipRects++;
	}

	@:noCompletion private override function __render(object:IBitmapDrawable):Void
	{
		if (!__stage.__transparent)
		{
			element.style.background = __stage.__colorString;
		}
		else
		{
			element.style.background = "none";
		}

		__z = 1;
		__renderDrawable(object);
	}

	@:noCompletion private function __renderDrawable(object:IBitmapDrawable):Void
	{
		if (object == null) return;

		switch (object.__drawableType)
		{
			case BITMAP_DATA:
			// DOMBitmapData.renderDrawable(cast object, this);
			case STAGE, SPRITE:
				DOMDisplayObjectContainer.renderDrawable(cast object, this);
			case BITMAP:
				DOMBitmap.renderDrawable(cast object, this);
			case SHAPE:
				DOMDisplayObject.renderDrawable(cast object, this);
			case SIMPLE_BUTTON:
				DOMSimpleButton.renderDrawable(cast object, this);
			case TEXT_FIELD:
				DOMTextField.renderDrawable(cast object, this);
			case VIDEO:
				DOMVideo.renderDrawable(cast object, this);
			case TILEMAP:
				DOMTilemap.renderDrawable(cast object, this);
			case DOM_ELEMENT:
				#if (js && html5)
				var domElement:DOMElement = cast object;
				if (domElement.stage != null && domElement.__worldVisible && domElement.__renderable)
				{
					if (!domElement.__active)
					{
						__initializeElement(domElement, domElement.__element);
						domElement.__active = true;
					}

					__updateClip(domElement);
					__applyStyle(domElement, true, true, true);
				}
				else
				{
					if (domElement.__active)
					{
						element.removeChild(domElement.__element);
						domElement.__active = false;
					}
				}

				DOMDisplayObject.renderDrawable(domElement, this);
				#end
			default:
		}
	}

	@:noCompletion private function __renderDrawableClear(object:IBitmapDrawable):Void
	{
		if (object == null) return;

		switch (object.__drawableType)
		{
			case BITMAP_DATA:
			// DOMBitmapData.renderDrawableClear(cast object, this);
			case STAGE, SPRITE:
				DOMDisplayObjectContainer.renderDrawableClear(cast object, this);
			case BITMAP:
				DOMBitmap.renderDrawableClear(cast object, this);
			case SHAPE:
				DOMDisplayObject.renderDrawableClear(cast object, this);
			case SIMPLE_BUTTON:
				DOMSimpleButton.renderDrawableClear(cast object, this);
			case TEXT_FIELD:
				DOMTextField.renderDrawableClear(cast object, this);
			case VIDEO:
				DOMVideo.renderDrawableClear(cast object, this);
			case TILEMAP:
				DOMTilemap.renderDrawableClear(cast object, this);
			default:
		}
	}

	@:noCompletion private override function __setBlendMode(value:BlendMode):Void
	{
		if (__overrideBlendMode != null) value = __overrideBlendMode;
		if (__blendMode == value) return;

		__blendMode = value;

		// if (__context != null) {

		// 	switch (blendMode) {

		// 		case ADD:

		// 			__context.globalCompositeOperation = "lighter";

		// 		case ALPHA:

		// 			__context.globalCompositeOperation = "destination-in";

		// 		case DARKEN:

		// 			__context.globalCompositeOperation = "darken";

		// 		case DIFFERENCE:

		// 			__context.globalCompositeOperation = "difference";

		// 		case ERASE:

		// 			__context.globalCompositeOperation = "destination-out";

		// 		case HARDLIGHT:

		// 			__context.globalCompositeOperation = "hard-light";

		// 		//case INVERT:

		// 			//__context.globalCompositeOperation = "";

		// 		case LAYER:

		// 			__context.globalCompositeOperation = "source-over";

		// 		case LIGHTEN:

		// 			__context.globalCompositeOperation = "lighten";

		// 		case MULTIPLY:

		// 			__context.globalCompositeOperation = "multiply";

		// 		case OVERLAY:

		// 			__context.globalCompositeOperation = "overlay";

		// 		case SCREEN:

		// 			__context.globalCompositeOperation = "screen";

		// 		//case SHADER:

		// 			//__context.globalCompositeOperation = "";

		// 		//case SUBTRACT:

		// 			//__context.globalCompositeOperation = "";

		// 		default:

		// 			__context.globalCompositeOperation = "source-over";

		// 	}

		// }
	}

	@:noCompletion private function __updateClip(displayObject:DisplayObject):Void
	{
		if (__currentClipRect == null)
		{
			displayObject.__worldClipChanged = (displayObject.__worldClip != null);
			displayObject.__worldClip = null;
		}
		else
		{
			if (displayObject.__worldClip == null)
			{
				displayObject.__worldClip = new Rectangle();
			}

			var clip = Rectangle.__pool.get();
			var matrix = Matrix.__pool.get();

			matrix.copyFrom(displayObject.__renderTransform);
			matrix.invert();

			__currentClipRect.__transform(clip, matrix);

			if (clip.equals(displayObject.__worldClip))
			{
				displayObject.__worldClipChanged = false;
			}
			else
			{
				displayObject.__worldClip.copyFrom(clip);
				displayObject.__worldClipChanged = true;
			}

			Rectangle.__pool.release(clip);
			Matrix.__pool.release(matrix);
		}
	}
}
#else
typedef DOMRenderer = Dynamic;
#end
