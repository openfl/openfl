package openfl.display;

#if openfl_html5
import js.html.Element;
import openfl.display._internal.*;
import openfl.display._CanvasRenderer;
import openfl.display.Bitmap;
import openfl.display.BlendMode;
import openfl.display.DOMElement;
import openfl.display.DOMRenderer as DOMRendererAPI;
import openfl.display.DisplayObject;
import openfl.display.DisplayObjectContainer;
import openfl.display.IBitmapDrawable;
import openfl.display.SimpleButton;
import openfl.display.Tilemap;
import openfl.events.RenderEvent;
import openfl.events._RenderEvent;
import openfl.events._Event;
import openfl.geom.ColorTransform;
import openfl.geom.Matrix;
import openfl.geom._Matrix;
import openfl.geom.Rectangle;
import openfl.geom._Rectangle;
import openfl.media.Video;
import openfl.text.TextField;
import openfl.text._TextField;
#if !lime
import openfl._internal.backend.lime_standalone.DOMRenderContext;
#else
import lime.graphics.DOMRenderContext;
#end

#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
@:noCompletion
class _DOMRenderer extends _DisplayObjectRenderer
{
	public var element:#if (lime || openfl_html5) DOMRenderContext #else Dynamic #end;
	public var pixelRatio:Float = 1;

	public var __canvasRenderer:CanvasRenderer;
	public var __clipRects:Array<Rectangle>;
	public var __colorTransform:ColorTransform;
	public var __currentClipRect:Rectangle;
	public var __numClipRects:Int;
	public var __transformOriginProperty:String;
	public var __transformProperty:String;
	public var __vendorPrefix:String;
	public var __z:Int;

	private var domRenderer:DOMRenderer;

	public function new(domRenderer:DOMRenderer, element:DOMRenderContext)
	{
		this.domRenderer = domRenderer;

		super(domRenderer);

		this.element = element;

		_DisplayObject.__supportDOM = true;

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
		(__canvasRenderer._ : _CanvasRenderer).__domRenderer = this.domRenderer;
	}

	public function applyStyle(parent:DisplayObject, childElement:Element):Void
	{
		if (parent != null && childElement != null)
		{
			if ((parent._ : _DisplayObject).__renderData.style == null || childElement.parentElement != element)
			{
				__initializeElement(parent, childElement);
			}

				(parent._ : _DisplayObject).__renderData.style = childElement.style;

			__updateClip(parent);
			__applyStyle(parent, true, true, true);
		}
	}

	public function clearStyle(childElement:Element):Void
	{
		if (childElement != null && childElement.parentElement == element)
		{
			element.removeChild(childElement);
		}
	}

	public function __applyStyle(displayObject:DisplayObject, setTransform:Bool, setAlpha:Bool, setClip:Bool):Void
	{
		#if openfl_html5
		var style = (displayObject._ : _DisplayObject).__renderData.style;

		// TODO: displayMatrix

		if (setTransform && (displayObject._ : _DisplayObject).__renderTransformChanged)
		{
			style.setProperty(__transformProperty, (displayObject._ : _DisplayObject).__renderTransform._.to3DString(__roundPixels), null);
		}

		if ((displayObject._ : _DisplayObject).__worldZ != ++__z)
		{
			(displayObject._ : _DisplayObject).__worldZ = __z;
			style.setProperty("z-index", Std.string((displayObject._ : _DisplayObject).__worldZ), null);
		}

		if (setAlpha && (displayObject._ : _DisplayObject).__worldAlphaChanged)
		{
			if ((displayObject._ : _DisplayObject).__worldAlpha < 1)
			{
				style.setProperty("opacity", Std.string((displayObject._ : _DisplayObject).__worldAlpha), null);
			}
			else
			{
				style.removeProperty("opacity");
			}
		}

		if (setClip && (displayObject._ : _DisplayObject).__worldClipChanged)
		{
			if ((displayObject._ : _DisplayObject).__worldClip == null)
			{
				style.removeProperty("clip");
			}
			else
			{
				var clip = (displayObject._ : _DisplayObject).__worldClip;
				style.setProperty("clip", "rect(" + clip.y + "px, " + clip.right + "px, " + clip.bottom + "px, " + clip.x + "px)", null);
			}
		}
		#end
	}

	public function __clearBitmap(bitmap:Bitmap):Void
	{
		DOMDisplayObject.clear(bitmap, this.domRenderer);
		DOMBitmap.clear(bitmap, this.domRenderer);
	}

	public function __clearDisplayObject(object:DisplayObject):Void
	{
		if (object != null && (object._ : _DisplayObject).__type != null)
		{
			switch ((object._ : _DisplayObject).__type)
			{
				case BITMAP:
					__clearBitmap(cast object);
				case DISPLAY_OBJECT_CONTAINER, MOVIE_CLIP:
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

	public function __clearDisplayObjectContainer(container:DisplayObjectContainer):Void
	{
		for (orphan in (container._ : _DisplayObjectContainer).__removedChildren)
		{
			if (orphan.stage == null)
			{
				__clearDisplayObject(orphan);
			}
		}

			(container._ : _DisplayObjectContainer).__cleanupRemovedChildren();

		__clearShape(cast container);

		var child = (container._ : _DisplayObjectContainer).__firstChild;
		while (child != null)
		{
			__clearDisplayObject(child);
			child = (child._ : _DisplayObject).__nextSibling;
		}
	}

	public function __clearDOMElement(domElement:DOMElement):Void
	{
		DOMDisplayObject.clear(domElement, this.domRenderer);
	}

	public function __clearShape(shape:DisplayObject):Void
	{
		DOMDisplayObject.clear(shape, this.domRenderer);
	}

	public function __clearSimpleButton(button:SimpleButton):Void
	{
		for (previousState in (button._ : _SimpleButton).__previousStates)
		{
			__clearDisplayObject(previousState);
		}

		if ((button._ : _SimpleButton).__currentState != null)
		{
			__clearDisplayObject((button._ : _SimpleButton).__currentState);
		}
	}

	public function __clearTextField(textField:TextField):Void
	{
		DOMDisplayObject.clear(textField, this.domRenderer);
		DOMTextField.clear(textField, this.domRenderer);
	}

	public function __clearTilemap(tilemap:Tilemap):Void
	{
		DOMDisplayObject.clear(tilemap, this.domRenderer);
		DOMTilemap.clear(tilemap, this.domRenderer);
	}

	public function __clearVideo(video:Video):Void
	{
		DOMDisplayObject.clear(video, this.domRenderer);
		DOMVideo.clear(video, this.domRenderer);
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

	#if openfl_html5
	public function __initializeElement(displayObject:DisplayObject, element:Element):Void
	{
		var style = (displayObject._ : _DisplayObject).__renderData.style = element.style;

		style.setProperty("position", "absolute", null);
		style.setProperty("top", "0", null);
		style.setProperty("left", "0", null);
		style.setProperty(__transformOriginProperty, "0 0 0", null);

		this.element.appendChild(element);

		(displayObject._ : _DisplayObject).__worldAlphaChanged = true;
		(displayObject._ : _DisplayObject).__renderTransformChanged = true;
		(displayObject._ : _DisplayObject).__worldVisibleChanged = true;
		(displayObject._ : _DisplayObject).__worldClipChanged = true;
		(displayObject._ : _DisplayObject).__worldClip = null;
		(displayObject._ : _DisplayObject).__worldZ = -1;
	}
	#end

	public function __popMask():Void
	{
		__popMaskRect();
	}

	public function __popMaskObject(object:DisplayObject, handleScrollRect:Bool = true):Void
	{
		if ((object._ : _DisplayObject).__mask != null)
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

	public function __pushMask(mask:DisplayObject):Void
	{
		// TODO: Handle true mask shape, as well as alpha test

		__pushMaskRect(mask.getBounds(mask), (mask._ : _DisplayObject).__renderTransform);
	}

	public function __pushMaskObject(object:DisplayObject, handleScrollRect:Bool = true):Void
	{
		if (handleScrollRect && (object._ : _DisplayObject).__scrollRect != null)
		{
			__pushMaskRect((object._ : _DisplayObject).__scrollRect, (object._ : _DisplayObject).__renderTransform);
		}

		if ((object._ : _DisplayObject).__mask != null)
		{
			__pushMask((object._ : _DisplayObject).__mask);
		}
	}

	public function __pushMaskRect(rect:Rectangle, transform:Matrix):Void
	{
		// TODO: Handle rotation?

		if (__numClipRects == __clipRects.length)
		{
			__clipRects[__numClipRects] = new Rectangle();
		}

		var clipRect = __clipRects[__numClipRects];
		rect._.__transform(clipRect, transform);

		if (__numClipRects > 0)
		{
			var parentClipRect = __clipRects[__numClipRects - 1];
			clipRect._.__contract(parentClipRect.x, parentClipRect.y, parentClipRect.width, parentClipRect.height);
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

	public override function __render(object:IBitmapDrawable):Void
	{
		if (!(__stage._ : _Stage).__transparent)
		{
			element.style.background = (__stage._ : _Stage).__colorString;
		}
		else
		{
			element.style.background = "none";
		}

		__z = 1;

		// TODO: BitmapData render
		if (object != null && (object._ : _DisplayObject).__type != null)
		{
			__renderDisplayObject(cast object);
		}
	}

	public function __renderBitmap(bitmap:Bitmap):Void
	{
		(__canvasRenderer._ : _CanvasRenderer).__updateCacheBitmap(bitmap, /*!__worldColorTransform._.__isDefault ()*/ false);

		if ((bitmap._ : _Bitmap).__renderData.cacheBitmap != null && !(bitmap._ : _Bitmap).__renderData.isCacheBitmapRender)
		{
			__clearBitmap(bitmap);
			((bitmap._ : _Bitmap).__renderData.cacheBitmap._ : _Bitmap).stage = bitmap.stage;

			DOMBitmap.render((bitmap._ : _Bitmap).__renderData.cacheBitmap, this.domRenderer);
		}
		else
		{
			DOMDisplayObject.render(bitmap, this.domRenderer);
			DOMBitmap.render(bitmap, this.domRenderer);
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

			if ((object._ : _DisplayObject).__customRenderEvent != null)
			{
				var event = (object._ : _DisplayObject).__customRenderEvent;
				event.allowSmoothing = __allowSmoothing;
				event.objectMatrix.copyFrom((object._ : _DisplayObject).__renderTransform);
				event.objectColorTransform._.__copyFrom((object._ : _DisplayObject).__worldColorTransform);
				(event._ : _RenderEvent).renderer = this.domRenderer;

				if (object.stage != null && (object._ : _DisplayObject).__worldVisible)
				{
					(event._ : _Event).type = RenderEvent.RENDER_DOM;
				}
				else
				{
					(event._ : _Event).type = RenderEvent.CLEAR_DOM;
				}

				__setBlendMode((object._ : _DisplayObject).__worldBlendMode);
				__pushMaskObject(object);

				object.dispatchEvent(event);

				__popMaskObject(object);
			}
		}
	}

	public function __renderDisplayObjectContainer(container:DisplayObjectContainer):Void
	{
		for (orphan in (container._ : _DisplayObjectContainer).__removedChildren)
		{
			if (orphan.stage == null)
			{
				__clearDisplayObject(orphan);
			}
		}

			(container._ : _DisplayObjectContainer).__cleanupRemovedChildren();

		(__canvasRenderer._ : _CanvasRenderer).__updateCacheBitmap(container, /*!__worldColorTransform._.__isDefault ()*/ false);

		if ((container._ : _DisplayObjectContainer).__renderData.cacheBitmap != null
			&& !(container._ : _DisplayObjectContainer).__renderData.isCacheBitmapRender)
		{
			__clearDisplayObjectContainer(container);
			((container._ : _DisplayObjectContainer).__renderData.cacheBitmap._ : _Bitmap).stage = container.stage;

			DOMBitmap.render((container._ : _DisplayObjectContainer).__renderData.cacheBitmap, this.domRenderer);
		}
		else
		{
			DOMDisplayObject.render(container, this.domRenderer);

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
	}

	public function __renderDOMElement(domElement:DOMElement):Void
	{
		if (domElement.stage != null && (domElement._ : _DOMElement).__worldVisible && (domElement._ : _DOMElement).__renderable)
		{
			if (!(domElement._ : _DOMElement).__active)
			{
				__initializeElement(domElement, (domElement._ : _DOMElement).__element);
				(domElement._ : _DOMElement).__active = true;
			}

			__updateClip(domElement);
			__applyStyle(domElement, true, true, true);
		}
		else
		{
			if ((domElement._ : _DOMElement).__active)
			{
				element.removeChild((domElement._ : _DOMElement).__element);
				(domElement._ : _DOMElement).__active = false;
			}
		}

		DOMDisplayObject.render(domElement, this.domRenderer);
	}

	public function __renderShape(shape:DisplayObject):Void
	{
		(__canvasRenderer._ : _CanvasRenderer).__updateCacheBitmap(shape, /*!__worldColorTransform._.__isDefault ()*/ false);

		if ((shape._ : _Shape).__renderData.cacheBitmap != null && !(shape._ : _Shape).__renderData.isCacheBitmapRender)
		{
			__clearShape(shape);
			((shape._ : _Shape).__renderData.cacheBitmap._ : _Bitmap).stage = shape.stage;

			DOMBitmap.render((shape._ : _Shape).__renderData.cacheBitmap, this.domRenderer);
		}
		else
		{
			DOMDisplayObject.render(shape, this.domRenderer);
		}
	}

	public function __renderSimpleButton(button:SimpleButton):Void
	{
		__pushMaskObject(button);

		for (previousState in (button._ : _SimpleButton).__previousStates)
		{
			__clearDisplayObject(previousState);
		}

			(button._ : _SimpleButton).__previousStates.length = 0;

		if ((button._ : _SimpleButton).__currentState != null)
		{
			if ((button._ : _SimpleButton).__currentState.stage != button.stage)
			{
				((button._ : _SimpleButton).__currentState._ : _DisplayObject).__setStageReferences(button.stage);
			}

			__renderDisplayObject((button._ : _SimpleButton).__currentState);
		}

		__popMaskObject(button);
	}

	public function __renderTextField(textField:TextField):Void
	{
		#if openfl_html5
		(textField._ : _TextField).__domRender = true;
		(__canvasRenderer._ : _CanvasRenderer).__updateCacheBitmap(textField,
			(textField._ : _TextField).__forceCachedBitmapUpdate || /*!__worldColorTransform._.__isDefault ()*/ false);
		(textField._ : _TextField).__forceCachedBitmapUpdate = false;
		(textField._ : _TextField).__domRender = false;

		if ((textField._ : _TextField).__renderData.cacheBitmap != null && !(textField._ : _TextField).__renderData.isCacheBitmapRender)
		{
			__clearTextField(textField);
			((textField._ : _TextField).__renderData.cacheBitmap._ : _Bitmap).stage = textField.stage;

			DOMBitmap.render((textField._ : _TextField).__renderData.cacheBitmap, this.domRenderer);
		}
		else
		{
			if ((textField._ : _TextField).__renderedOnCanvasWhileOnDOM)
			{
				(textField._ : _TextField).__renderedOnCanvasWhileOnDOM = false;

				if ((textField._ : _TextField).__isHTML && (textField._ : _TextField).__rawHtmlText != null)
				{
					(textField._ : _TextField).__updateText((textField._ : _TextField).__rawHtmlText);
					(textField._ : _TextField).__dirty = true;
					(textField._ : _TextField).__layoutDirty = true;
					(textField._ : _TextField).__setRenderDirty();
				}
			}

			DOMTextField.render(textField, this.domRenderer);
		}
		#end
	}

	public function __renderTilemap(tilemap:Tilemap):Void
	{
		(__canvasRenderer._ : _CanvasRenderer).__updateCacheBitmap(tilemap, /*!__worldColorTransform._.__isDefault ()*/ false);

		if ((tilemap._ : _Tilemap).__renderData.cacheBitmap != null && !(tilemap._ : _Tilemap).__renderData.isCacheBitmapRender)
		{
			__clearTilemap(tilemap);
			((tilemap._ : _Tilemap).__renderData.cacheBitmap._ : _DisplayObject).stage = tilemap.stage;

			DOMBitmap.render((tilemap._ : _Tilemap).__renderData.cacheBitmap, this.domRenderer);
		}
		else
		{
			DOMDisplayObject.render(tilemap, this.domRenderer);
			DOMTilemap.render(tilemap, this.domRenderer);
		}
	}

	public function __renderVideo(video:Video):Void
	{
		DOMVideo.render(video, this.domRenderer);
	}

	public function __setBlendMode(value:BlendMode):Void
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

	public function __updateCacheBitmap(object:DisplayObject, force:Bool):Bool
	{
		var bitmap = (object._ : _DisplayObject).__renderData.cacheBitmap;
		var updated = (__canvasRenderer._ : _CanvasRenderer).__updateCacheBitmap(object, force);

		if (updated && bitmap != null && (object._ : _DisplayObject).__renderData.cacheBitmap == null)
		{
			__clearBitmap(bitmap);
		}

		return updated;
	}

	public function __updateClip(displayObject:DisplayObject):Void
	{
		if (__currentClipRect == null)
		{
			(displayObject._ : _DisplayObject).__worldClipChanged = ((displayObject._ : _DisplayObject).__worldClip != null);
			(displayObject._ : _DisplayObject).__worldClip = null;
		}
		else
		{
			if ((displayObject._ : _DisplayObject).__worldClip == null)
			{
				(displayObject._ : _DisplayObject).__worldClip = new Rectangle();
			}

			var clip = _Rectangle.__pool.get();
			var matrix = _Matrix.__pool.get();

			matrix.copyFrom((displayObject._ : _DisplayObject).__renderTransform);
			matrix.invert();

			__currentClipRect._.__transform(clip, matrix);

			if (clip.equals((displayObject._ : _DisplayObject).__worldClip))
			{
				(displayObject._ : _DisplayObject).__worldClipChanged = false;
			}
			else
			{
				(displayObject._ : _DisplayObject).__worldClip.copyFrom(clip);
				(displayObject._ : _DisplayObject).__worldClipChanged = true;
			}

			_Rectangle.__pool.release(clip);
			_Matrix.__pool.release(matrix);
		}
	}
}
#end
