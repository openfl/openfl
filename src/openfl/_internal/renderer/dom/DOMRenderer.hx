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

	private function new(element:#if lime DOMRenderContext #else Dynamic #end)
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
		__canvasRenderer.__isDOM = true;
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

	private function __clearBitmap(bitmap:Bitmap):Void
	{
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

		for (child in container.__children)
		{
			__clearDisplayObject(child);
		}
	}

	private function __clearDOMElement(domElement:DOMElement):Void
	{
		DOMDisplayObject.clear(domElement, this);
	}

	private function __clearShape(shape:Shape):Void
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
		DOMTextField.clear(textField, this);
	}

	private function __clearTilemap(tilemap:Tilemap):Void
	{
		DOMTilemap.clear(tilemap, this);
	}

	private function __clearVideo(video:Video):Void
	{
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
		__updateCacheBitmap(bitmap, /*!__worldColorTransform.__isDefault ()*/ false);

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

		__updateCacheBitmap(container, /*!__worldColorTransform.__isDefault ()*/ false);

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

	private function __renderShape(shape:Shape):Void
	{
		__updateCacheBitmap(shape, /*!__worldColorTransform.__isDefault ()*/ false);

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
		__updateCacheBitmap(textField, textField.__forceCachedBitmapUpdate || /*!__worldColorTransform.__isDefault ()*/ false);
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
		__updateCacheBitmap(tilemap, /*!__worldColorTransform.__isDefault ()*/ false);

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
		#if lime
		if (object.__isCacheBitmapRender) return false;
		#if openfl_disable_cacheasbitmap
		return false;
		#end

		var colorTransform = ColorTransform.__pool.get();
		colorTransform.__copyFrom(object.__worldColorTransform);
		if (__worldColorTransform != null) colorTransform.__combine(__worldColorTransform);
		var updated = false;

		if (object.cacheAsBitmap || (__type != OPENGL && !colorTransform.__isDefault(true)))
		{
			var rect = null;

			var needRender = (object.__cacheBitmap == null
				|| (object.__renderDirty && (force || (object.__children != null && object.__children.length > 0)))
				|| object.opaqueBackground != object.__cacheBitmapBackground);
			var softwareDirty = needRender
				|| (object.__graphics != null && object.__graphics.__softwareDirty)
				|| !object.__cacheBitmapColorTransform.__equals(colorTransform, true);
			var hardwareDirty = needRender || (object.__graphics != null && object.__graphics.__hardwareDirty);

			var renderType = __type;

			if (softwareDirty || hardwareDirty)
			{
				// #if !openfl_force_gl_cacheasbitmap
				// if (renderType == OPENGL)
				// {
				// 	if (#if !openfl_disable_gl_cacheasbitmap __shouldCacheHardware(object, null) == false #else true #end)
				// 	{
				// 		#if (js && html5)
				// 		renderType = CANVAS;
				// 		#else
				// 		renderType = CAIRO;
				// 		#end
				// 	}
				// }
				// #end

				if (softwareDirty && (renderType == CANVAS || renderType == CAIRO)) needRender = true;
				if (hardwareDirty && renderType == OPENGL) needRender = true;
			}

			var updateTransform = (needRender || !object.__cacheBitmap.__worldTransform.equals(object.__worldTransform));
			var hasFilters = #if !openfl_disable_filters object.__filters != null #else false #end;

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

			if (object.__cacheBitmapMatrix == null)
			{
				object.__cacheBitmapMatrix = new Matrix();
			}

			var bitmapMatrix = (object.__cacheAsBitmapMatrix != null ? object.__cacheAsBitmapMatrix : object.__renderTransform);

			if (!needRender
				&& (bitmapMatrix.a != object.__cacheBitmapMatrix.a
					|| bitmapMatrix.b != object.__cacheBitmapMatrix.b
					|| bitmapMatrix.c != object.__cacheBitmapMatrix.c
					|| bitmapMatrix.d != object.__cacheBitmapMatrix.d))
			{
				needRender = true;
			}

			if (!needRender
				&& __type != OPENGL
				&& object.__cacheBitmapData != null
				&& object.__cacheBitmapData.image != null
				&& object.__cacheBitmapData.image.version < object.__cacheBitmapData.__textureVersion)
			{
				needRender = true;
			}

			object.__cacheBitmapMatrix.copyFrom(bitmapMatrix);
			object.__cacheBitmapMatrix.tx = 0;
			object.__cacheBitmapMatrix.ty = 0;

			// TODO: Handle dimensions better if object has a scrollRect?

			var bitmapWidth = 0, bitmapHeight = 0;
			var filterWidth = 0, filterHeight = 0;
			var offsetX = 0., offsetY = 0.;

			if (updateTransform || needRender)
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
				updateTransform = true;
				object.__cacheBitmapBackground = object.opaqueBackground;

				if (filterWidth >= 0.5 && filterHeight >= 0.5)
				{
					var needsFill = (object.opaqueBackground != null && (bitmapWidth != filterWidth || bitmapHeight != filterHeight));
					var fillColor = object.opaqueBackground != null ? (0xFF << 24) | object.opaqueBackground : 0;
					var bitmapColor = needsFill ? 0 : fillColor;
					var allowFramebuffer = (__type == OPENGL);

					if (object.__cacheBitmapData == null
						|| bitmapWidth > object.__cacheBitmapData.width
						|| bitmapHeight > object.__cacheBitmapData.height)
					{
						object.__cacheBitmapData = new BitmapData(bitmapWidth, bitmapHeight, true, bitmapColor);

						if (object.__cacheBitmap == null) object.__cacheBitmap = new Bitmap();
						object.__cacheBitmap.__bitmapData = object.__cacheBitmapData;
						object.__cacheBitmapRenderer = null;
					}
					else
					{
						object.__cacheBitmapData.__fillRect(object.__cacheBitmapData.rect, bitmapColor, allowFramebuffer);
					}

					if (needsFill)
					{
						rect.setTo(0, 0, filterWidth, filterHeight);
						object.__cacheBitmapData.__fillRect(rect, fillColor, allowFramebuffer);
					}
				}
				else
				{
					ColorTransform.__pool.release(colorTransform);

					object.__cacheBitmap = null;
					object.__cacheBitmapData = null;
					object.__cacheBitmapData2 = null;
					object.__cacheBitmapData3 = null;
					object.__cacheBitmapRenderer = null;

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

			if (updateTransform || needRender)
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
			// __cacheBitmap.__scrollRect = __scrollRect;
			// __cacheBitmap.filters = filters;
			object.__cacheBitmap.mask = object.__mask;

			if (needRender)
			{
				#if lime
				if (object.__cacheBitmapRenderer == null || renderType != object.__cacheBitmapRenderer.__type)
				{
					// if (renderType == OPENGL)
					// {
					// 	#if opengl_renderer
					// 	object.__cacheBitmapRenderer = new OpenGLRenderer(cast(this, OpenGLRenderer).__context3D, object.__cacheBitmapData);
					// 	#else
					// 	object.__cacheBitmapRenderer = new Context3DRenderer(cast(this, Context3DRenderer).context3D, object.__cacheBitmapData);
					// 	#end
					// }
					// else
					// {
					if (object.__cacheBitmapData.image == null)
					{
						var color = object.opaqueBackground != null ? (0xFF << 24) | object.opaqueBackground : 0;
						object.__cacheBitmapData = new BitmapData(bitmapWidth, bitmapHeight, true, color);
						object.__cacheBitmap.__bitmapData = object.__cacheBitmapData;
					}

					#if (js && html5)
					ImageCanvasUtil.convertToCanvas(object.__cacheBitmapData.image);
					object.__cacheBitmapRenderer = new CanvasRenderer(object.__cacheBitmapData.image.buffer.__srcContext);
					// #else
					// object.__cacheBitmapRenderer = new CairoRenderer(new Cairo(object.__cacheBitmapData.getSurface()));
					#end
					// }

					object.__cacheBitmapRenderer.__worldTransform = new Matrix();
					object.__cacheBitmapRenderer.__worldColorTransform = new ColorTransform();
				}
				#else
				return false;
				#end

				if (object.__cacheBitmapColorTransform == null) object.__cacheBitmapColorTransform = new ColorTransform();

				object.__cacheBitmapRenderer.__stage = object.stage;

				object.__cacheBitmapRenderer.__allowSmoothing = __allowSmoothing;
				// object.__cacheBitmapRenderer.__setBlendMode(NORMAL);
				object.__cacheBitmapRenderer.__worldAlpha = 1 / object.__worldAlpha;

				object.__cacheBitmapRenderer.__worldTransform.copyFrom(object.__renderTransform);
				object.__cacheBitmapRenderer.__worldTransform.invert();
				object.__cacheBitmapRenderer.__worldTransform.concat(object.__cacheBitmapMatrix);
				object.__cacheBitmapRenderer.__worldTransform.tx -= offsetX;
				object.__cacheBitmapRenderer.__worldTransform.ty -= offsetY;

				object.__cacheBitmapRenderer.__worldColorTransform.__copyFrom(colorTransform);
				object.__cacheBitmapRenderer.__worldColorTransform.__invert();

				object.__isCacheBitmapRender = true;

				// if (object.__cacheBitmapRenderer.__type == OPENGL)
				// {
				// 	#if opengl_renderer
				// 	var parentRenderer:OpenGLRenderer = cast renderer;
				// 	var childRenderer:OpenGLRenderer = cast object.__cacheBitmapRenderer;
				// 	var context = childRenderer.__context3D;
				// 	#else
				// 	var parentRenderer:Context3DRenderer = cast renderer;
				// 	var childRenderer:Context3DRenderer = cast object.__cacheBitmapRenderer;
				// 	var context = childRenderer.context3D;
				// 	#end

				// 	var cacheRTT = context.__state.renderToTexture;
				// 	var cacheRTTDepthStencil = context.__state.renderToTextureDepthStencil;
				// 	var cacheRTTAntiAlias = context.__state.renderToTextureAntiAlias;
				// 	var cacheRTTSurfaceSelector = context.__state.renderToTextureSurfaceSelector;

				// 	// var cacheFramebuffer = context.__contextState.__currentGLFramebuffer;

				// 	var cacheBlendMode = parentRenderer.__blendMode;
				// 	parentRenderer.__suspendClipAndMask();
				// 	childRenderer.__copyShader(parentRenderer);
				// 	// childRenderer.__copyState (parentRenderer);

				// 	object.__cacheBitmapData.__setUVRect(context, 0, 0, filterWidth, filterHeight);
				// 	childRenderer.__setRenderTarget(object.__cacheBitmapData);
				// 	if (object.__cacheBitmapData.image != null) object.__cacheBitmapData.__textureVersion = object.__cacheBitmapData.image.version + 1;

				// 	#if opengl_renderer
				// 	object.__cacheBitmapData.__drawGL(object, childRenderer);
				// 	#else
				// 	object.__cacheBitmapData.__drawContext3D(object, childRenderer);
				// 	#end

				// 	if (hasFilters)
				// 	{
				// 		var needSecondBitmapData = true;
				// 		var needCopyOfOriginal = false;

				// 		for (filter in object.__filters)
				// 		{
				// 			// if (filter.__needSecondBitmapData) {
				// 			// 	needSecondBitmapData = true;
				// 			// }
				// 			if (filter.__preserveObject)
				// 			{
				// 				needCopyOfOriginal = true;
				// 			}
				// 		}

				// 		var bitmap = object.__cacheBitmapData;
				// 		var bitmap2 = null;
				// 		var bitmap3 = null;

				// 		// if (needSecondBitmapData) {
				// 		if (object.__cacheBitmapData2 == null
				// 			|| bitmapWidth > object.__cacheBitmapData2.width
				// 			|| bitmapHeight > object.__cacheBitmapData2.height)
				// 		{
				// 			object.__cacheBitmapData2 = new BitmapData(bitmapWidth, bitmapHeight, true, 0);
				// 		}
				// 		else
				// 		{
				// 			object.__cacheBitmapData2.fillRect(object.__cacheBitmapData2.rect, 0);
				// 			if (object.__cacheBitmapData2.image != null)
				// 			{
				// 				object.__cacheBitmapData2.__textureVersion = object.__cacheBitmapData2.image.version + 1;
				// 			}
				// 		}
				// 		object.__cacheBitmapData2.__setUVRect(context, 0, 0, filterWidth, filterHeight);
				// 		bitmap2 = object.__cacheBitmapData2;
				// 		// } else {
				// 		// 	bitmap2 = bitmapData;
				// 		// }

				// 		if (needCopyOfOriginal)
				// 		{
				// 			if (object.__cacheBitmapData3 == null
				// 				|| bitmapWidth > object.__cacheBitmapData3.width
				// 				|| bitmapHeight > object.__cacheBitmapData3.height)
				// 			{
				// 				object.__cacheBitmapData3 = new BitmapData(bitmapWidth, bitmapHeight, true, 0);
				// 			}
				// 			else
				// 			{
				// 				object.__cacheBitmapData3.fillRect(object.__cacheBitmapData3.rect, 0);
				// 				if (object.__cacheBitmapData3.image != null)
				// 				{
				// 					object.__cacheBitmapData3.__textureVersion = object.__cacheBitmapData3.image.version + 1;
				// 				}
				// 			}
				// 			object.__cacheBitmapData3.__setUVRect(context, 0, 0, filterWidth, filterHeight);
				// 			bitmap3 = object.__cacheBitmapData3;
				// 		}

				// 		childRenderer.__setBlendMode(NORMAL);
				// 		childRenderer.__worldAlpha = 1;
				// 		childRenderer.__worldTransform.identity();
				// 		childRenderer.__worldColorTransform.__identity();

				// 		// var sourceRect = bitmap.rect;
				// 		// if (__tempPoint == null) __tempPoint = new Point ();
				// 		// var destPoint = __tempPoint;
				// 		var shader, cacheBitmap;

				// 		for (filter in object.__filters)
				// 		{
				// 			if (filter.__preserveObject)
				// 			{
				// 				childRenderer.__setRenderTarget(bitmap3);
				// 				childRenderer.__renderFilterPass(bitmap, childRenderer.__defaultDisplayShader, filter.__smooth);
				// 			}

				// 			for (i in 0...filter.__numShaderPasses)
				// 			{
				// 				shader = filter.__initShader(childRenderer, i, filter.__preserveObject ? bitmap3 : null);
				// 				childRenderer.__setBlendMode(filter.__shaderBlendMode);
				// 				childRenderer.__setRenderTarget(bitmap2);
				// 				childRenderer.__renderFilterPass(bitmap, shader, filter.__smooth);

				// 				cacheBitmap = bitmap;
				// 				bitmap = bitmap2;
				// 				bitmap2 = cacheBitmap;
				// 			}

				// 			filter.__renderDirty = false;
				// 		}

				// 		object.__cacheBitmap.__bitmapData = bitmap;
				// 	}

				// 	parentRenderer.__blendMode = NORMAL;
				// 	parentRenderer.__setBlendMode(cacheBlendMode);
				// 	parentRenderer.__copyShader(childRenderer);

				// 	if (cacheRTT != null)
				// 	{
				// 		context.setRenderToTexture(cacheRTT, cacheRTTDepthStencil, cacheRTTAntiAlias, cacheRTTSurfaceSelector);
				// 	}
				// 	else
				// 	{
				// 		context.setRenderToBackBuffer();
				// 	}

				// 	// context.__bindGLFramebuffer (cacheFramebuffer);

				// 	// parentRenderer.__restoreState (childRenderer);
				// 	parentRenderer.__resumeClipAndMask(childRenderer);
				// 	parentRenderer.setViewport();

				// 	object.__cacheBitmapColorTransform.__copyFrom(colorTransform);
				// }
				// else
				// {
				// TODO: Does this cause issues with display matrix, etc?
				__canvasRenderer.__drawBitmapData(object.__cacheBitmapData, object, null);

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

						// Adding __cacheBitmapRenderer = null; makes this work
						cacheBitmap = object.__cacheBitmapData;
						object.__cacheBitmapData = bitmap;
						object.__cacheBitmapData2 = cacheBitmap;
						object.__cacheBitmap.__bitmapData = object.__cacheBitmapData;
						object.__cacheBitmapRenderer = null;
					}

					object.__cacheBitmap.__imageVersion = object.__cacheBitmapData.__textureVersion;
				}

				object.__cacheBitmapColorTransform.__copyFrom(colorTransform);

				if (!object.__cacheBitmapColorTransform.__isDefault(true))
				{
					object.__cacheBitmapColorTransform.alphaMultiplier = 1;
					object.__cacheBitmapData.colorTransform(object.__cacheBitmapData.rect, object.__cacheBitmapColorTransform);
				}
				// }

				object.__isCacheBitmapRender = false;
			}

			if (updateTransform || needRender)
			{
				Rectangle.__pool.release(rect);
			}

			updated = updateTransform;
		}
		else if (object.__cacheBitmap != null)
		{
			// if (__type == DOM)
			// {
			__clearDisplayObject(object.__cacheBitmap);
			// }

			object.__cacheBitmap = null;
			object.__cacheBitmapData = null;
			object.__cacheBitmapData2 = null;
			object.__cacheBitmapData3 = null;
			object.__cacheBitmapColorTransform = null;
			object.__cacheBitmapRenderer = null;

			updated = true;
		}

		ColorTransform.__pool.release(colorTransform);

		return updated;
		#else
		return false;
		#end
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
