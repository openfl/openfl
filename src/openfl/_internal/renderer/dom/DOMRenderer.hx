package openfl._internal.renderer.dom;

import js.html.Element;
import lime._internal.graphics.ImageCanvasUtil;
import lime.graphics.DOMRenderContext;
import openfl._internal.renderer.canvas.CanvasRenderer;
import openfl.display.Bitmap;
import openfl.display.BitmapData;
import openfl.display.BlendMode;
import openfl.display.DOMElement;
import openfl.display.DOMRenderer as DOMRendererAPI;
import openfl.display.DisplayObject;
import openfl.display.DisplayObjectContainer;
import openfl.display.IBitmapDrawable;
import openfl.display.Shape;
import openfl.display.SimpleButton;
import openfl.display.Tilemap;
import openfl.events.RenderEvent;
import openfl.geom.ColorTransform;
import openfl.geom.Matrix;
import openfl.geom.Point;
import openfl.geom.Rectangle;
import openfl.media.Video;
import openfl.text.TextField;

/**
	**BETA**

	The DOMRenderer API exposes support for HTML5 DOM render instructions within the
	`RenderEvent.RENDER_DOM` event
**/
#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
@:access(lime.graphics.ImageBuffer)
@:access(openfl._internal.renderer.canvas.CanvasRenderer)
@:access(openfl.display.BitmapData)
@:access(openfl.display.DisplayObject)
@:access(openfl.display.Graphics)
@:access(openfl.display.IBitmapDrawable)
@:access(openfl.display.Stage3D)
@:access(openfl.events.RenderEvent)
@:access(openfl.filters.BitmapFilter)
@:access(openfl.geom.ColorTransform)
@:access(openfl.geom.Matrix)
@:access(openfl.geom.Rectangle)
@:allow(openfl._internal.renderer.dom)
@SuppressWarnings("checkstyle:FieldDocComment")
class DOMRenderer extends DOMRendererAPI
{
	private var __canvasRenderer:CanvasRenderer;
	private var __clipRects:Array<Rectangle>;
	private var __colorTransform:ColorTransform;
	private var __currentClipRect:Rectangle;
	private var __numClipRects:Int;
	private var __transformOriginProperty:String;
	private var __transformProperty:String;
	private var __vendorPrefix:String;
	private var __z:Int;

	private function new(element:DOMRenderContext)
	{
		super(element);

		DisplayObject.__supportDOM = true;

		var prefix = untyped __js__("(function () {
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

		__clipRects = new Array();
		__colorTransform = new ColorTransform();
		__numClipRects = 0;
		__z = 0;

		__type = DOM;

		__canvasRenderer = new CanvasRenderer(null);
		__canvasRenderer.__domRenderer = this;
	}

	public override function applyStyle(parent:DisplayObject, childElement:Element):Void
	{
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
	}

	public override function clearStyle(childElement:Element):Void
	{
		if (childElement != null && childElement.parentElement == element)
		{
			element.removeChild(childElement);
		}
	}

	private function __applyStyle(displayObject:DisplayObject, setTransform:Bool, setAlpha:Bool, setClip:Bool):Void
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

	private override function __clearBitmap(bitmap:Bitmap):Void
	{
		DOMDisplayObject.clear(bitmap, this);
		DOMBitmap.clear(bitmap, this);
	}

	private function __clearDisplayObject(object:DisplayObject):Void
	{
		if (object != null && object.__type != null)
		{
			switch (object.__type)
			{
				case BITMAP:
					__clearBitmap(cast object);
				case DISPLAY_OBJECT_CONTAINER:
					__clearDisplayObjectContainer(cast object);
				case DOM_ELEMENT:
					__clearDOMElement(cast object);
				case DISPLAY_OBJECT, SHAPE:
					__clearShape(cast object);
				case SIMPLE_BUTTON:
					__clearSimpleButton(cast object);
				case TEXTFIELD:
					__clearTextField(cast object);
				case TILEMAP:
					__clearTilemap(cast object);
				case VIDEO:
					__clearVideo(cast object);
				default:
			}
		}
	}

	private function __clearDisplayObjectContainer(container:DisplayObjectContainer):Void
	{
		for (orphan in container.__removedChildren)
		{
			if (orphan.stage == null)
			{
				__clearDisplayObject(orphan);
			}
		}

		container.__cleanupRemovedChildren();

		__clearShape(cast container);

		for (child in container.__children)
		{
			__clearDisplayObject(child);
		}
	}

	private function __clearDOMElement(domElement:DOMElement):Void
	{
		DOMDisplayObject.clear(domElement, this);
	}

	private function __clearShape(shape:DisplayObject):Void
	{
		DOMDisplayObject.clear(shape, this);
	}

	private function __clearSimpleButton(button:SimpleButton):Void
	{
		for (previousState in button.__previousStates)
		{
			__clearDisplayObject(previousState);
		}

		if (button.__currentState != null)
		{
			__clearDisplayObject(button.__currentState);
		}
	}

	private function __clearTextField(textField:TextField):Void
	{
		DOMDisplayObject.clear(textField, this);
		DOMTextField.clear(textField, this);
	}

	private function __clearTilemap(tilemap:Tilemap):Void
	{
		DOMDisplayObject.clear(tilemap, this);
		DOMTilemap.clear(tilemap, this);
	}

	private function __clearVideo(video:Video):Void
	{
		DOMDisplayObject.clear(video, this);
		DOMVideo.clear(video, this);
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

	#if (js && html5)
	private function __initializeElement(displayObject:DisplayObject, element:Element):Void
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

	private function __popMask():Void
	{
		__popMaskRect();
	}

	private function __popMaskObject(object:DisplayObject, handleScrollRect:Bool = true):Void
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

	private function __popMaskRect():Void
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

	private function __pushMask(mask:DisplayObject):Void
	{
		// TODO: Handle true mask shape, as well as alpha test

		__pushMaskRect(mask.getBounds(mask), mask.__renderTransform);
	}

	private function __pushMaskObject(object:DisplayObject, handleScrollRect:Bool = true):Void
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

	private function __pushMaskRect(rect:Rectangle, transform:Matrix):Void
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

	private override function __render(object:IBitmapDrawable):Void
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

		// TODO: BitmapData render
		if (object != null && object.__type != null)
		{
			__renderDisplayObject(cast object);
		}
	}

	private function __renderBitmap(bitmap:Bitmap):Void
	{
		__canvasRenderer.__updateCacheBitmap(bitmap, /*!__worldColorTransform.__isDefault ()*/ false);

		if (bitmap.__cacheBitmap != null && !bitmap.__isCacheBitmapRender)
		{
			__clearBitmap(bitmap);
			bitmap.__cacheBitmap.stage = bitmap.stage;

			DOMBitmap.render(bitmap.__cacheBitmap, this);
		}
		else
		{
			DOMDisplayObject.render(bitmap, this);
			DOMBitmap.render(bitmap, this);
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
				case DOM_ELEMENT:
					__renderDOMElement(cast object);
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
					return;
			}

			if (object.__customRenderEvent != null)
			{
				var event = object.__customRenderEvent;
				event.allowSmoothing = __allowSmoothing;
				event.objectMatrix.copyFrom(object.__renderTransform);
				event.objectColorTransform.__copyFrom(object.__worldColorTransform);
				event.renderer = this;

				if (object.stage != null && object.__worldVisible)
				{
					event.type = RenderEvent.RENDER_DOM;
				}
				else
				{
					event.type = RenderEvent.CLEAR_DOM;
				}

				__setBlendMode(object.__worldBlendMode);
				__pushMaskObject(object);

				object.dispatchEvent(event);

				__popMaskObject(object);
			}
		}
	}

	private function __renderDisplayObjectContainer(container:DisplayObjectContainer):Void
	{
		for (orphan in container.__removedChildren)
		{
			if (orphan.stage == null)
			{
				__clearDisplayObject(orphan);
			}
		}

		container.__cleanupRemovedChildren();

		__canvasRenderer.__updateCacheBitmap(container, /*!__worldColorTransform.__isDefault ()*/ false);

		if (container.__cacheBitmap != null && !container.__isCacheBitmapRender)
		{
			__clearDisplayObjectContainer(container);
			container.__cacheBitmap.stage = container.stage;

			DOMBitmap.render(container.__cacheBitmap, this);
		}
		else
		{
			DOMDisplayObject.render(container, this);

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
	}

	private function __renderDOMElement(domElement:DOMElement):Void
	{
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

		DOMDisplayObject.render(domElement, this);
	}

	private function __renderShape(shape:DisplayObject):Void
	{
		__canvasRenderer.__updateCacheBitmap(shape, /*!__worldColorTransform.__isDefault ()*/ false);

		if (shape.__cacheBitmap != null && !shape.__isCacheBitmapRender)
		{
			__clearShape(shape);
			shape.__cacheBitmap.stage = shape.stage;

			DOMBitmap.render(shape.__cacheBitmap, this);
		}
		else
		{
			DOMDisplayObject.render(shape, this);
		}
	}

	private function __renderSimpleButton(button:SimpleButton):Void
	{
		__pushMaskObject(button);

		for (previousState in button.__previousStates)
		{
			__clearDisplayObject(previousState);
		}

		button.__previousStates.length = 0;

		if (button.__currentState != null)
		{
			if (button.__currentState.stage != button.stage)
			{
				button.__currentState.__setStageReference(button.stage);
			}

			__renderDisplayObject(button.__currentState);
		}

		__popMaskObject(button);
	}

	private function __renderTextField(textField:TextField):Void
	{
		#if (js && html5)
		textField.__domRender = true;
		__canvasRenderer.__updateCacheBitmap(textField, textField.__forceCachedBitmapUpdate
			|| /*!__worldColorTransform.__isDefault ()*/ false);
		textField.__forceCachedBitmapUpdate = false;
		textField.__domRender = false;

		if (textField.__cacheBitmap != null && !textField.__isCacheBitmapRender)
		{
			__clearTextField(textField);
			textField.__cacheBitmap.stage = textField.stage;

			DOMBitmap.render(textField.__cacheBitmap, this);
		}
		else
		{
			if (textField.__renderedOnCanvasWhileOnDOM)
			{
				textField.__renderedOnCanvasWhileOnDOM = false;

				if (textField.__isHTML && textField.__rawHtmlText != null)
				{
					textField.__updateText(textField.__rawHtmlText);
					textField.__dirty = true;
					textField.__layoutDirty = true;
					textField.__setRenderDirty();
				}
			}

			DOMTextField.render(textField, this);
		}
		#end
	}

	private function __renderTilemap(tilemap:Tilemap):Void
	{
		__canvasRenderer.__updateCacheBitmap(tilemap, /*!__worldColorTransform.__isDefault ()*/ false);

		if (tilemap.__cacheBitmap != null && !tilemap.__isCacheBitmapRender)
		{
			__clearTilemap(tilemap);
			tilemap.__cacheBitmap.stage = tilemap.stage;

			DOMBitmap.render(tilemap.__cacheBitmap, this);
		}
		else
		{
			DOMDisplayObject.render(tilemap, this);
			DOMTilemap.render(tilemap, this);
		}
	}

	private function __renderVideo(video:Video):Void
	{
		DOMVideo.render(video, this);
	}

	private function __setBlendMode(value:BlendMode):Void
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

	private function __updateCacheBitmap(object:DisplayObject, force:Bool):Bool
	{
		var bitmap = object.__cacheBitmap;
		var updated = __canvasRenderer.__updateCacheBitmap(object, force);

		if (updated && bitmap != null && object.__cacheBitmap == null)
		{
			__clearBitmap(bitmap);
		}

		return updated;
	}

	private function __updateClip(displayObject:DisplayObject):Void
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
