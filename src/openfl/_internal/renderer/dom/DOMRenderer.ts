import CanvasRenderer from "../../../_internal/renderer/canvas/CanvasRenderer";
import DisplayObjectRendererType from "../../../_internal/renderer/DisplayObjectRendererType";
import DisplayObjectType from "../../../_internal/renderer/DisplayObjectType";
import * as internal from "../../../_internal/utils/InternalAccess";
import Bitmap from "../../../display/Bitmap";
import BlendMode from "../../../display/BlendMode";
import DOMElement from "../../../display/DOMElement";
import DOMRendererAPI from "../../../display/DOMRenderer";
import DisplayObject from "../../../display/DisplayObject";
import DisplayObjectContainer from "../../../display/DisplayObjectContainer";
import IBitmapDrawable from "../../../display/IBitmapDrawable";
import SimpleButton from "../../../display/SimpleButton";
import Tilemap from "../../../display/Tilemap";
import RenderEvent from "../../../events/RenderEvent";
import ColorTransform from "../../../geom/ColorTransform";
import Matrix from "../../../geom/Matrix";
import Rectangle from "../../../geom/Rectangle";
import Video from "../../../media/Video";
import TextField from "../../../text/TextField";
// import openfl._internal.backend.lime_standalone.DOMRenderContext;
import DOMBitmap from "./DOMBitmap";
import DOMDisplayObject from "./DOMDisplayObject";
import DOMShape from "./DOMShape";
import DOMTextField from "./DOMTextField";
import DOMTilemap from "./DOMTilemap";
import DOMVideo from "./DOMVideo";

/**
	**BETA**

	The DOMRenderer API exposes support for HTML5 DOM render instructions within the
	`RenderEvent.RENDER_DOM` event
**/
export default class DOMRenderer extends DOMRendererAPI
{
	public __canvasRenderer: CanvasRenderer;
	public __clipRects: Array<Rectangle>;
	public __colorTransform: ColorTransform;
	public __currentClipRect: Rectangle;
	public __numClipRects: number;
	public __transformOriginProperty: string;
	public __transformProperty: string;
	public __vendorPrefix: string;
	public __z: number;

	public constructor(element: HTMLElement)
	{
		super(element);

		(<internal.DisplayObject><any>DisplayObject).__supportDOM = true;

		var prefix = (function ()
		{
			var styles = window.getComputedStyle(document.documentElement, ''),
				pre = (Array.prototype.slice
					.call(styles)
					.join('')
					.match(/-(moz|webkit|ms)-/) || (styles["OLink"] === '' && ['', 'o'])
				)[1],
				dom = ('WebKit|Moz|MS|O').match(new RegExp('(' + pre + ')', 'i'))[1];
			return {
				dom: dom,
				lowercase: pre,
				css: '-' + pre + '-',
				js: pre[0].toUpperCase() + pre.substr(1)
			};
		})();

		this.__vendorPrefix = prefix.lowercase;
		this.__transformProperty = (prefix.lowercase == "webkit") ? "-webkit-transform" : "transform";
		this.__transformOriginProperty = (prefix.lowercase == "webkit") ? "-webkit-transform-origin" : "transform-origin";

		this.__clipRects = new Array();
		this.__colorTransform = new ColorTransform();
		this.__numClipRects = 0;
		this.__z = 0;

		this.__type = DisplayObjectRendererType.DOM;

		this.__canvasRenderer = new CanvasRenderer(null);
		(<any>this.__canvasRenderer).__domRenderer = this;
	}

	public applyStyle(parent: DisplayObject, childElement: HTMLElement): void
	{
		if (parent != null && childElement != null)
		{
			if ((<internal.DisplayObject><any>parent).__renderData.style == null || childElement.parentElement != this.element)
			{
				this.__initializeElement(parent, childElement);
			}

			(<internal.DisplayObject><any>parent).__renderData.style = childElement.style;

			this.__updateClip(parent);
			this.__applyStyle(parent, true, true, true);
		}
	}

	public clearStyle(childElement: Element): void
	{
		if (childElement != null && childElement.parentElement == this.element)
		{
			this.element.removeChild(childElement);
		}
	}

	public __applyStyle(displayObject: DisplayObject, setTransform: boolean, setAlpha: boolean, setClip: boolean): void
	{
		var style = (<internal.DisplayObject><any>displayObject).__renderData.style;

		// TODO: displayMatrix

		if (setTransform && (<internal.DisplayObject><any>displayObject).__renderTransformChanged)
		{
			style.setProperty(this.__transformProperty, (<internal.DisplayObject><any>displayObject).__renderTransform.to3DString(this.__roundPixels), null);
		}

		if ((<internal.DisplayObject><any>displayObject).__worldZ != ++this.__z)
		{
			(<internal.DisplayObject><any>displayObject).__worldZ = this.__z;
			style.setProperty("z-index", String((<internal.DisplayObject><any>displayObject).__worldZ), null);
		}

		if (setAlpha && (<internal.DisplayObject><any>displayObject).__worldAlphaChanged)
		{
			if ((<internal.DisplayObject><any>displayObject).__worldAlpha < 1)
			{
				style.setProperty("opacity", String((<internal.DisplayObject><any>displayObject).__worldAlpha), null);
			}
			else
			{
				style.removeProperty("opacity");
			}
		}

		if (setClip && (<internal.DisplayObject><any>displayObject).__worldClipChanged)
		{
			if ((<internal.DisplayObject><any>displayObject).__worldClip == null)
			{
				style.removeProperty("clip");
			}
			else
			{
				var clip = (<internal.DisplayObject><any>displayObject).__worldClip;
				style.setProperty("clip", "rect(" + clip.y + "px, " + clip.right + "px, " + clip.bottom + "px, " + clip.x + "px)", null);
			}
		}
	}

	protected __clearBitmap(bitmap: Bitmap): void
	{
		DOMDisplayObject.clear(bitmap, this);
		DOMBitmap.clear(bitmap, this);
	}

	public __clearDisplayObject(object: DisplayObject): void
	{
		if (object != null && (<internal.DisplayObject><any>object).__type != null)
		{
			switch ((<internal.DisplayObject><any>object).__type)
			{
				case DisplayObjectType.BITMAP:
					this.__clearBitmap(object as Bitmap);
					break;
				case DisplayObjectType.DISPLAY_OBJECT_CONTAINER:
				case DisplayObjectType.MOVIE_CLIP:
					this.__clearDisplayObjectContainer(object as DisplayObjectContainer);
					break;
				case DisplayObjectType.DOM_ELEMENT:
					this.__clearDOMElement(object as DOMElement);
					break;
				case DisplayObjectType.DISPLAY_OBJECT:
				case DisplayObjectType.SHAPE:
					this.__clearShape(object);
					break;
				case DisplayObjectType.SIMPLE_BUTTON:
					this.__clearSimpleButton(object as SimpleButton);
					break;
				case DisplayObjectType.TEXTFIELD:
					this.__clearTextField(object as TextField);
					break;
				case DisplayObjectType.TILEMAP:
					this.__clearTilemap(object as Tilemap);
					break;
				case DisplayObjectType.VIDEO:
					this.__clearVideo(object as Video);
					break;
				default:
			}
		}
	}

	public __clearDisplayObjectContainer(container: DisplayObjectContainer): void
	{
		for (let orphan of (<internal.DisplayObjectContainer><any>container).__removedChildren)
		{
			if (orphan.stage == null)
			{
				this.__clearDisplayObject(orphan);
			}
		}

		(<internal.DisplayObjectContainer><any>container).__cleanupRemovedChildren();

		this.__clearShape(container);

		var child = (<internal.DisplayObject><any>container).__firstChild;
		while (child != null)
		{
			this.__clearDisplayObject(child);
			child = (<internal.DisplayObject><any>child).__nextSibling;
		}
	}

	public __clearDOMElement(domElement: DOMElement): void
	{
		DOMDisplayObject.clear(domElement, this);
	}

	public __clearShape(shape: DisplayObject): void
	{
		DOMDisplayObject.clear(shape, this);
	}

	public __clearSimpleButton(button: SimpleButton): void
	{
		for (let previousState of (<internal.SimpleButton><any>button).__previousStates)
		{
			this.__clearDisplayObject(previousState);
		}

		if ((<internal.SimpleButton><any>button).__currentState != null)
		{
			this.__clearDisplayObject((<internal.SimpleButton><any>button).__currentState);
		}
	}

	public __clearTextField(textField: TextField): void
	{
		DOMDisplayObject.clear(textField, this);
		DOMTextField.clear(textField, this);
	}

	public __clearTilemap(tilemap: Tilemap): void
	{
		DOMDisplayObject.clear(tilemap, this);
		DOMTilemap.clear(tilemap, this);
	}

	public __clearVideo(video: Video): void
	{
		DOMDisplayObject.clear(video, this);
		DOMVideo.clear(video, this);
	}

	public __getAlpha(value: number): number
	{
		return value * this.__worldAlpha;
	}

	public __getColorTransform(value: ColorTransform): ColorTransform
	{
		if (this.__worldColorTransform != null)
		{
			(<internal.ColorTransform><any>this.__colorTransform).__copyFrom(this.__worldColorTransform);
			(<internal.ColorTransform><any>this.__colorTransform).__combine(value);
			return this.__colorTransform;
		}
		else
		{
			return value;
		}
	}

	public __initializeElement(displayObject: DisplayObject, element: HTMLElement): void
	{
		var style = (<internal.DisplayObject><any>displayObject).__renderData.style = element.style;

		style.setProperty("position", "absolute", null);
		style.setProperty("top", "0", null);
		style.setProperty("left", "0", null);
		style.setProperty(this.__transformOriginProperty, "0 0 0", null);

		this.element.appendChild(element);

		(<internal.DisplayObject><any>displayObject).__worldAlphaChanged = true;
		(<internal.DisplayObject><any>displayObject).__renderTransformChanged = true;
		(<internal.DisplayObject><any>displayObject).__worldVisibleChanged = true;
		(<internal.DisplayObject><any>displayObject).__worldClipChanged = true;
		(<internal.DisplayObject><any>displayObject).__worldClip = null;
		(<internal.DisplayObject><any>displayObject).__worldZ = -1;
	}

	public __popMask(): void
	{
		this.__popMaskRect();
	}

	public __popMaskObject(object: DisplayObject, handleScrollRect: boolean = true): void
	{
		if ((<internal.DisplayObject><any>object).__mask != null)
		{
			this.__popMask();
		}

		if (handleScrollRect && (<internal.DisplayObject><any>object).__scrollRect != null)
		{
			this.__popMaskRect();
		}
	}

	public __popMaskRect(): void
	{
		if (this.__numClipRects > 0)
		{
			this.__numClipRects--;

			if (this.__numClipRects > 0)
			{
				this.__currentClipRect = this.__clipRects[this.__numClipRects - 1];
			}
			else
			{
				this.__currentClipRect = null;
			}
		}
	}

	public __pushMask(mask: DisplayObject): void
	{
		// TODO: Handle true mask shape, as well as alpha test

		this.__pushMaskRect(mask.getBounds(mask), (<internal.DisplayObject><any>mask).__renderTransform);
	}

	public __pushMaskObject(object: DisplayObject, handleScrollRect: boolean = true): void
	{
		if (handleScrollRect && (<internal.DisplayObject><any>object).__scrollRect != null)
		{
			this.__pushMaskRect((<internal.DisplayObject><any>object).__scrollRect, (<internal.DisplayObject><any>object).__renderTransform);
		}

		if ((<internal.DisplayObject><any>object).__mask != null)
		{
			this.__pushMask((<internal.DisplayObject><any>object).__mask);
		}
	}

	public __pushMaskRect(rect: Rectangle, transform: Matrix): void
	{
		// TODO: Handle rotation?

		if (this.__numClipRects == this.__clipRects.length)
		{
			this.__clipRects[this.__numClipRects] = new Rectangle();
		}

		var clipRect = this.__clipRects[this.__numClipRects];
		(<internal.Rectangle><any>rect).__transform(clipRect, transform);

		if (this.__numClipRects > 0)
		{
			var parentClipRect = this.__clipRects[this.__numClipRects - 1];
			(<internal.Rectangle><any>clipRect).__contract(parentClipRect.x, parentClipRect.y, parentClipRect.width, parentClipRect.height);
		}

		if (clipRect.height < 0)
		{
			clipRect.height = 0;
		}

		if (clipRect.width < 0)
		{
			clipRect.width = 0;
		}

		this.__currentClipRect = clipRect;
		this.__numClipRects++;
	}

	public __render(object: IBitmapDrawable): void
	{
		if (!(<internal.Stage><any>this.__stage).__transparent)
		{
			this.element.style.background = (<internal.Stage><any>this.__stage).__colorString;
		}
		else
		{
			this.element.style.background = "none";
		}

		this.__z = 1;

		// TODO: BitmapData render
		if (object != null && (<internal.DisplayObject><any>object).__type != null)
		{
			this.__renderDisplayObject(object as DisplayObject);
		}
	}

	public __renderBitmap(bitmap: Bitmap): void
	{
		this.__canvasRenderer.__updateCacheBitmap(bitmap, /*!__worldColorTransform.__isDefault ()*/ false);

		if ((<internal.DisplayObject><any>bitmap).__renderData.cacheBitmap != null && !(<internal.DisplayObject><any>bitmap).__renderData.isCacheBitmapRender)
		{
			this.__clearBitmap(bitmap);
			(<internal.DisplayObject><any>(<internal.DisplayObject><any>bitmap).__renderData.cacheBitmap).__stage = bitmap.stage;

			DOMBitmap.render((<internal.DisplayObject><any>bitmap).__renderData.cacheBitmap, this);
		}
		else
		{
			DOMDisplayObject.render(bitmap, this);
			DOMBitmap.render(bitmap, this);
		}
	}

	public __renderDisplayObject(object: DisplayObject): void
	{
		if (object != null && (<internal.DisplayObject><any>object).__type != null)
		{
			switch ((<internal.DisplayObject><any>object).__type)
			{
				case DisplayObjectType.BITMAP:
					this.__renderBitmap(object as Bitmap);
					break;
				case DisplayObjectType.DISPLAY_OBJECT_CONTAINER:
				case DisplayObjectType.MOVIE_CLIP:
					this.__renderDisplayObjectContainer(object as DisplayObjectContainer);
					break;
				case DisplayObjectType.DOM_ELEMENT:
					this.__renderDOMElement(object as DOMElement);
					break;
				case DisplayObjectType.DISPLAY_OBJECT:
				case DisplayObjectType.SHAPE:
					this.__renderShape(object);
					break;
				case DisplayObjectType.SIMPLE_BUTTON:
					this.__renderSimpleButton(object as SimpleButton);
					break;
				case DisplayObjectType.TEXTFIELD:
					this.__renderTextField(object as TextField);
					break;
				case DisplayObjectType.TILEMAP:
					this.__renderTilemap(object as Tilemap);
					break;
				case DisplayObjectType.VIDEO:
					this.__renderVideo(object as Video);
					break;
				default:
					return;
			}

			if ((<internal.DisplayObject><any>object).__customRenderEvent != null)
			{
				var event = (<internal.DisplayObject><any>object).__customRenderEvent;
				event.allowSmoothing = this.__allowSmoothing;
				event.objectMatrix.copyFrom((<internal.DisplayObject><any>object).__renderTransform);
				(<internal.ColorTransform><any>event.objectColorTransform).__copyFrom((<internal.DisplayObject><any>object).__worldColorTransform);
				(<internal.RenderEvent><any>event).__renderer = this;

				if (object.stage != null && (<internal.DisplayObject><any>object).__worldVisible)
				{
					(<internal.Event><any>event).__type = RenderEvent.RENDER_DOM;
				}
				else
				{
					(<internal.Event><any>event).__type = RenderEvent.CLEAR_DOM;
				}

				this.__setBlendMode((<internal.DisplayObject><any>object).__worldBlendMode);
				this.__pushMaskObject(object);

				object.dispatchEvent(event);

				this.__popMaskObject(object);
			}
		}
	}

	public __renderDisplayObjectContainer(container: DisplayObjectContainer): void
	{
		for (let orphan of (<internal.DisplayObjectContainer><any>container).__removedChildren)
		{
			if (orphan.stage == null)
			{
				this.__clearDisplayObject(orphan);
			}
		}

		(<internal.DisplayObjectContainer><any>container).__cleanupRemovedChildren();

		this.__canvasRenderer.__updateCacheBitmap(container, /*!__worldColorTransform.__isDefault ()*/ false);

		if ((<internal.DisplayObject><any>container).__renderData.cacheBitmap != null && !(<internal.DisplayObject><any>container).__renderData.isCacheBitmapRender)
		{
			this.__clearDisplayObjectContainer(container);
			(<internal.DisplayObject><any>(<internal.DisplayObject><any>container).__renderData.cacheBitmap).__stage = container.stage;

			DOMBitmap.render((<internal.DisplayObject><any>container).__renderData.cacheBitmap, this);
		}
		else
		{
			DOMDisplayObject.render(container, this);

			if ((<internal.DisplayObject><any>container).__renderData.cacheBitmap != null && !(<internal.DisplayObject><any>container).__renderData.isCacheBitmapRender) return;

			this.__pushMaskObject(container);

			var child = (<internal.DisplayObject><any>container).__firstChild;
			if (this.__stage != null)
			{
				while (child != null)
				{
					this.__renderDisplayObject(child);
					(<internal.DisplayObject><any>child).__renderDirty = false;
					child = (<internal.DisplayObject><any>child).__nextSibling;
				}

				(<internal.DisplayObject><any>container).__renderDirty = false;
			}
			else
			{
				while (child != null)
				{
					this.__renderDisplayObject(child);
					child = (<internal.DisplayObject><any>child).__nextSibling;
				}
			}

			this.__popMaskObject(container);
		}
	}

	public __renderDOMElement(domElement: DOMElement): void
	{
		if (domElement.stage != null && (<internal.DisplayObject><any>domElement).__worldVisible && (<internal.DisplayObject><any>domElement).__renderable)
		{
			if (!(<internal.DOMElement><any>domElement).__active)
			{
				this.__initializeElement(domElement, (<internal.DOMElement><any>domElement).__element);
				(<internal.DOMElement><any>domElement).__active = true;
			}

			this.__updateClip(domElement);
			this.__applyStyle(domElement, true, true, true);
		}
		else
		{
			if ((<internal.DOMElement><any>domElement).__active)
			{
				this.element.removeChild((<internal.DOMElement><any>domElement).__element);
				(<internal.DOMElement><any>domElement).__active = false;
			}
		}

		DOMDisplayObject.render(domElement, this);
	}

	public __renderShape(shape: DisplayObject): void
	{
		this.__canvasRenderer.__updateCacheBitmap(shape, /*!__worldColorTransform.__isDefault ()*/ false);

		if ((<internal.DisplayObject><any>shape).__renderData.cacheBitmap != null && !(<internal.DisplayObject><any>shape).__renderData.isCacheBitmapRender)
		{
			this.__clearShape(shape);
			(<internal.DisplayObject><any>(<internal.DisplayObject><any>shape).__renderData.cacheBitmap).__stage = shape.stage;

			DOMBitmap.render((<internal.DisplayObject><any>shape).__renderData.cacheBitmap, this);
		}
		else
		{
			DOMDisplayObject.render(shape, this);
		}
	}

	public __renderSimpleButton(button: SimpleButton): void
	{
		this.__pushMaskObject(button);

		for (let previousState of (<internal.SimpleButton><any>button).__previousStates)
		{
			this.__clearDisplayObject(previousState);
		}

		(<internal.SimpleButton><any>button).__previousStates.length = 0;

		if ((<internal.SimpleButton><any>button).__currentState != null)
		{
			if ((<internal.SimpleButton><any>button).__currentState.stage != button.stage)
			{
				(<internal.DisplayObject><any>(<internal.SimpleButton><any>button).__currentState).__setStageReferences(button.stage);
			}

			this.__renderDisplayObject((<internal.SimpleButton><any>button).__currentState);
		}

		this.__popMaskObject(button);
	}

	public __renderTextField(textField: TextField): void
	{
		(<internal.TextField><any>textField).__domRender = true;
		this.__canvasRenderer.__updateCacheBitmap(textField, (<internal.TextField><any>textField).__forceCachedBitmapUpdate
			|| /*!__worldColorTransform.__isDefault ()*/ false);
		(<internal.TextField><any>textField).__forceCachedBitmapUpdate = false;
		(<internal.TextField><any>textField).__domRender = false;

		if ((<internal.DisplayObject><any>textField).__renderData.cacheBitmap != null && !(<internal.DisplayObject><any>textField).__renderData.isCacheBitmapRender)
		{
			this.__clearTextField(textField);
			(<internal.DisplayObject><any>(<internal.DisplayObject><any>textField).__renderData.cacheBitmap).__stage = textField.stage;

			DOMBitmap.render((<internal.DisplayObject><any>textField).__renderData.cacheBitmap, this);
		}
		else
		{
			if ((<internal.TextField><any>textField).__renderedOnCanvasWhileOnDOM)
			{
				(<internal.TextField><any>textField).__renderedOnCanvasWhileOnDOM = false;

				if ((<internal.TextField><any>textField).__isHTML && (<internal.TextField><any>textField).__rawHtmlText != null)
				{
					(<internal.TextField><any>textField).__updateText((<internal.TextField><any>textField).__rawHtmlText);
					(<internal.TextField><any>textField).__dirty = true;
					(<internal.TextField><any>textField).__layoutDirty = true;
					(<internal.TextField><any>textField).__setRenderDirty();
				}
			}

			DOMTextField.render(textField, this);
		}
	}

	public __renderTilemap(tilemap: Tilemap): void
	{
		this.__canvasRenderer.__updateCacheBitmap(tilemap, /*!__worldColorTransform.__isDefault ()*/ false);

		if ((<internal.DisplayObject><any>tilemap).__renderData.cacheBitmap != null && !(<internal.DisplayObject><any>tilemap).__renderData.isCacheBitmapRender)
		{
			this.__clearTilemap(tilemap);
			(<internal.DisplayObject><any>(<internal.DisplayObject><any>tilemap).__renderData.cacheBitmap).__stage = tilemap.stage;

			DOMBitmap.render((<internal.DisplayObject><any>tilemap).__renderData.cacheBitmap, this);
		}
		else
		{
			DOMDisplayObject.render(tilemap, this);
			DOMTilemap.render(tilemap, this);
		}
	}

	public __renderVideo(video: Video): void
	{
		DOMVideo.render(video, this);
	}

	public __setBlendMode(value: BlendMode): void
	{
		if (this.__overrideBlendMode != null) value = this.__overrideBlendMode;
		if (this.__blendMode == value) return;

		this.__blendMode = value;

		// if (__context != null) {

		// 	switch (blendMode) {

		// 		case ADD:

		// 			this.__context.globalCompositeOperation = "lighter";

		// 		case ALPHA:

		// 			this.__context.globalCompositeOperation = "destination-in";

		// 		case DARKEN:

		// 			this.__context.globalCompositeOperation = "darken";

		// 		case DIFFERENCE:

		// 			this.__context.globalCompositeOperation = "difference";

		// 		case ERASE:

		// 			this.__context.globalCompositeOperation = "destination-out";

		// 		case HARDLIGHT:

		// 			this.__context.globalCompositeOperation = "hard-light";

		// 		//case INVERT:

		// 			//__context.globalCompositeOperation = "";

		// 		case LAYER:

		// 			this.__context.globalCompositeOperation = "source-over";

		// 		case LIGHTEN:

		// 			this.__context.globalCompositeOperation = "lighten";

		// 		case MULTIPLY:

		// 			this.__context.globalCompositeOperation = "multiply";

		// 		case OVERLAY:

		// 			this.__context.globalCompositeOperation = "overlay";

		// 		case SCREEN:

		// 			this.__context.globalCompositeOperation = "screen";

		// 		//case SHADER:

		// 			//__context.globalCompositeOperation = "";

		// 		//case SUBTRACT:

		// 			//__context.globalCompositeOperation = "";

		// 		default:

		// 			this.__context.globalCompositeOperation = "source-over";

		// 	}

		// }
	}

	public __updateCacheBitmap(object: DisplayObject, force: boolean): boolean
	{
		var bitmap = (<internal.DisplayObject><any>object).__renderData.cacheBitmap;
		var updated = this.__canvasRenderer.__updateCacheBitmap(object, force);

		if (updated && bitmap != null && (<internal.DisplayObject><any>object).__renderData.cacheBitmap == null)
		{
			this.__clearBitmap(bitmap);
		}

		return updated;
	}

	public __updateClip(displayObject: DisplayObject): void
	{
		if (this.__currentClipRect == null)
		{
			(<internal.DisplayObject><any>displayObject).__worldClipChanged = ((<internal.DisplayObject><any>displayObject).__worldClip != null);
			(<internal.DisplayObject><any>displayObject).__worldClip = null;
		}
		else
		{
			if ((<internal.DisplayObject><any>displayObject).__worldClip == null)
			{
				(<internal.DisplayObject><any>displayObject).__worldClip = new Rectangle();
			}

			var clip = (<internal.Rectangle><any>Rectangle).__pool.get();
			var matrix = (<internal.Matrix><any>Matrix).__pool.get();

			matrix.copyFrom((<internal.DisplayObject><any>displayObject).__renderTransform);
			matrix.invert();

			(<internal.Rectangle><any>this.__currentClipRect).__transform(clip, matrix);

			if (clip.equals((<internal.DisplayObject><any>displayObject).__worldClip))
			{
				(<internal.DisplayObject><any>displayObject).__worldClipChanged = false;
			}
			else
			{
				(<internal.DisplayObject><any>displayObject).__worldClip.copyFrom(clip);
				(<internal.DisplayObject><any>displayObject).__worldClipChanged = true;
			}

			(<internal.Rectangle><any>Rectangle).__pool.release(clip);
			(<internal.Matrix><any>Matrix).__pool.release(matrix);
		}
	}
}
