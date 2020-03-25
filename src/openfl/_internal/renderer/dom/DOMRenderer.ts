namespace openfl._internal.renderer.dom;

#if openfl_html5
import js.html.Element;
import openfl._internal.renderer.canvas.CanvasRenderer;
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
import ColorTransfrom from "openfl/geom/ColorTransform";
import Matrix from "openfl/geom/Matrix";
import Rectangle from "openfl/geom/Rectangle";
import openfl.media.Video;
import openfl.text.TextField;
#if!lime
import openfl._internal.backend.lime_standalone.DOMRenderContext;
#else
import lime.graphics.DOMRenderContext;
#end

/**
	**BETA**

	The DOMRenderer API exposes support for HTML5 DOM render instructions within the
	`RenderEvent.RENDER_DOM` event
**/
#if!openfl_debug
@: fileXml('tags="haxe,release"')
@: noDebug
#end
@: access(lime.graphics.ImageBuffer)
@: access(openfl._internal.renderer.canvas.CanvasRenderer)
@: access(openfl.display.BitmapData)
@: access(openfl.display.DisplayObject)
@: access(openfl.display.Graphics)
@: access(openfl.display.IBitmapDrawable)
@: access(openfl.display.Stage3D)
@: access(openfl.events.RenderEvent)
@: access(openfl.filters.BitmapFilter)
@: access(openfl.geom.ColorTransform)
@: access(openfl.geom.Matrix)
@: access(openfl.geom.Rectangle)
@: allow(openfl._internal.renderer.dom)
@SuppressWarnings("checkstyle:FieldDocComment")
class DOMRenderer extends DOMRendererAPI
{
	private __canvasRenderer: CanvasRenderer;
	private __clipRects: Array<Rectangle>;
	private __colorTransform: ColorTransform;
	private __currentClipRect: Rectangle;
	private __numClipRects: number;
	private __transformOriginProperty: string;
	private __transformProperty: string;
	private __vendorPrefix: string;
	private __z: number;

	private new(element: DOMRenderContext)
	{
		super(element);

		DisplayObject.__supportDOM = true;

		var prefix = untyped __js__("(function () {
		  styles = window.getComputedStyle(document.documentElement, ''),
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
	}) ")();

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

publicapplyStyle(parent: DisplayObject, childElement: Element): void
	{
		if(parent != null && childElement != null)
{
	if (parent.__renderData.style == null || childElement.parentElement != element)
	{
		__initializeElement(parent, childElement);
	}

	parent.__renderData.style = childElement.style;

	__updateClip(parent);
	__applyStyle(parent, true, true, true);
}
}

publicclearStyle(childElement: Element): void
	{
		if(childElement != null && childElement.parentElement == element)
{
	element.removeChild(childElement);
}
}

private __applyStyle(displayObject: DisplayObject, setTransform : boolean, setAlpha : boolean, setClip : boolean): void
	{
		#if openfl_html5
	var style = displayObject.__renderData.style;

		// TODO: displayMatrix

		if(setTransform && displayObject.__renderTransformChanged)
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

private__clearBitmap(bitmap: Bitmap): void
	{
		DOMDisplayObject.clear(bitmap, this);
		DOMBitmap.clear(bitmap, this);
	}

private __clearDisplayObject(object: DisplayObject): void
	{
		if(object != null && object.__type != null)
{
	switch (object.__type)
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

private __clearDisplayObjectContainer(container: DisplayObjectContainer): void
	{
		for(orphan in container.__removedChildren)
	{
	if (orphan.stage == null)
	{
		__clearDisplayObject(orphan);
	}
}

container.__cleanupRemovedChildren();

__clearShape(cast container);

var child = container.__firstChild;
while (child != null)
{
	__clearDisplayObject(child);
	child = child.__nextSibling;
}
}

private __clearDOMElement(domElement: DOMElement): void
	{
		DOMDisplayObject.clear(domElement, this);
	}

private __clearShape(shape: DisplayObject): void
	{
		DOMDisplayObject.clear(shape, this);
	}

private __clearSimpleButton(button: SimpleButton): void
	{
		for(previousState in button.__previousStates)
	{
	__clearDisplayObject(previousState);
}

if (button.__currentState != null)
{
	__clearDisplayObject(button.__currentState);
}
}

private __clearTextField(textField: TextField): void
	{
		DOMDisplayObject.clear(textField, this);
		DOMTextField.clear(textField, this);
	}

private __clearTilemap(tilemap: Tilemap): void
	{
		DOMDisplayObject.clear(tilemap, this);
		DOMTilemap.clear(tilemap, this);
	}

private __clearVideo(video: Video): void
	{
		DOMDisplayObject.clear(video, this);
		DOMVideo.clear(video, this);
	}

private __getAlpha(value : number) : number
{
	return value * __worldAlpha;
}

private __getColorTransform(value: ColorTransform): ColorTransform
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

	#if openfl_html5
private __initializeElement(displayObject: DisplayObject, element: Element): void
	{
		var style = displayObject.__renderData.style = element.style;

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

private __popMask(): void
	{
		__popMaskRect();
	}

private __popMaskObject(object: DisplayObject, handleScrollRect : boolean = true): void
	{
		if(object.__mask != null)
	{
	__popMask();
}

if (handleScrollRect && object.__scrollRect != null)
{
	__popMaskRect();
}
}

private __popMaskRect(): void
	{
		if(__numClipRects > 0)
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

private __pushMask(mask: DisplayObject): void
	{
		// TODO: Handle true mask shape, as well as alpha test

		__pushMaskRect(mask.getBounds(mask), mask.__renderTransform);
	}

private __pushMaskObject(object: DisplayObject, handleScrollRect : boolean = true): void
	{
		if(handleScrollRect && object.__scrollRect != null)
{
	__pushMaskRect(object.__scrollRect, object.__renderTransform);
}

if (object.__mask != null)
{
	__pushMask(object.__mask);
}
}

private __pushMaskRect(rect: Rectangle, transform: Matrix): void
	{
		// TODO: Handle rotation?

		if(__numClipRects == __clipRects.length)
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

private__render(object: IBitmapDrawable): void
	{
		if(!__stage.__transparent)
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

private __renderBitmap(bitmap: Bitmap): void
	{
		__canvasRenderer.__updateCacheBitmap(bitmap, /*!__worldColorTransform.__isDefault ()*/ false);

		if(bitmap.__renderData.cacheBitmap != null && !bitmap.__renderData.isCacheBitmapRender)
	{
	__clearBitmap(bitmap);
	bitmap.__renderData.cacheBitmap.stage = bitmap.stage;

	DOMBitmap.render(bitmap.__renderData.cacheBitmap, this);
}
	else
{
	DOMDisplayObject.render(bitmap, this);
	DOMBitmap.render(bitmap, this);
}
}

private __renderDisplayObject(object: DisplayObject): void
	{
		if(object != null && object.__type != null)
{
	switch (object.__type)
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

private __renderDisplayObjectContainer(container: DisplayObjectContainer): void
	{
		for(orphan in container.__removedChildren)
	{
	if (orphan.stage == null)
	{
		__clearDisplayObject(orphan);
	}
}

container.__cleanupRemovedChildren();

__canvasRenderer.__updateCacheBitmap(container, /*!__worldColorTransform.__isDefault ()*/ false);

if (container.__renderData.cacheBitmap != null && !container.__renderData.isCacheBitmapRender)
{
	__clearDisplayObjectContainer(container);
	container.__renderData.cacheBitmap.stage = container.stage;

	DOMBitmap.render(container.__renderData.cacheBitmap, this);
}
else
{
	DOMDisplayObject.render(container, this);

	if (container.__renderData.cacheBitmap != null && !container.__renderData.isCacheBitmapRender) return;

	__pushMaskObject(container);

	var child = container.__firstChild;
	if (__stage != null)
	{
		while (child != null)
		{
			__renderDisplayObject(child);
			child.__renderDirty = false;
			child = child.__nextSibling;
		}

		container.__renderDirty = false;
	}
	else
	{
		while (child != null)
		{
			__renderDisplayObject(child);
			child = child.__nextSibling;
		}
	}

	__popMaskObject(container);
}
}

private __renderDOMElement(domElement: DOMElement): void
	{
		if(domElement.stage != null && domElement.__worldVisible && domElement.__renderable)
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

private __renderShape(shape: DisplayObject): void
	{
		__canvasRenderer.__updateCacheBitmap(shape, /*!__worldColorTransform.__isDefault ()*/ false);

		if(shape.__renderData.cacheBitmap != null && !shape.__renderData.isCacheBitmapRender)
	{
	__clearShape(shape);
	shape.__renderData.cacheBitmap.stage = shape.stage;

	DOMBitmap.render(shape.__renderData.cacheBitmap, this);
}
	else
{
	DOMDisplayObject.render(shape, this);
}
}

private __renderSimpleButton(button: SimpleButton): void
	{
		__pushMaskObject(button);

	for(previousState in button.__previousStates)
	{
	__clearDisplayObject(previousState);
}

button.__previousStates.length = 0;

if (button.__currentState != null)
{
	if (button.__currentState.stage != button.stage)
	{
		button.__currentState.__setStageReferences(button.stage);
	}

	__renderDisplayObject(button.__currentState);
}

__popMaskObject(button);
}

private __renderTextField(textField: TextField): void
	{
		#if openfl_html5
	textField.__domRender = true;
		__canvasRenderer.__updateCacheBitmap(textField, textField.__forceCachedBitmapUpdate
			|| /*!__worldColorTransform.__isDefault ()*/ false);
		textField.__forceCachedBitmapUpdate = false;
		textField.__domRender = false;

		if(textField.__renderData.cacheBitmap != null && !textField.__renderData.isCacheBitmapRender)
	{
	__clearTextField(textField);
	textField.__renderData.cacheBitmap.stage = textField.stage;

	DOMBitmap.render(textField.__renderData.cacheBitmap, this);
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

private __renderTilemap(tilemap: Tilemap): void
	{
		__canvasRenderer.__updateCacheBitmap(tilemap, /*!__worldColorTransform.__isDefault ()*/ false);

		if(tilemap.__renderData.cacheBitmap != null && !tilemap.__renderData.isCacheBitmapRender)
	{
	__clearTilemap(tilemap);
	tilemap.__renderData.cacheBitmap.stage = tilemap.stage;

	DOMBitmap.render(tilemap.__renderData.cacheBitmap, this);
}
	else
{
	DOMDisplayObject.render(tilemap, this);
	DOMTilemap.render(tilemap, this);
}
}

private __renderVideo(video: Video): void
	{
		DOMVideo.render(video, this);
	}

private __setBlendMode(value: BlendMode): void
	{
		if(__overrideBlendMode != null) value = __overrideBlendMode;
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

private __updateCacheBitmap(object: DisplayObject, force : boolean) : boolean
{
	var bitmap = object.__renderData.cacheBitmap;
	var updated = __canvasRenderer.__updateCacheBitmap(object, force);

	if (updated && bitmap != null && object.__renderData.cacheBitmap == null)
	{
		__clearBitmap(bitmap);
	}

	return updated;
}

private __updateClip(displayObject: DisplayObject): void
	{
		if(__currentClipRect == null)
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
#end
