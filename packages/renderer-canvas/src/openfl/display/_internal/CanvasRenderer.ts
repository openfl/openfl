import Bitmap from "../../../display/Bitmap";
import BitmapData from "../../../display/BitmapData";
import BlendMode from "../../../display/BlendMode";
import CanvasRendererAPI from "../../../display/CanvasRenderer";
import DisplayObject from "../../../display/DisplayObject";
import DisplayObjectContainer from "../../../display/DisplayObjectContainer";
import DOMRenderer from "../../../display/DOMRenderer";
import IBitmapDrawable from "../../../display/IBitmapDrawable";
import SimpleButton from "../../../display/SimpleButton";
import Tilemap from "../../../display/Tilemap";
import RenderEvent from "../../../events/RenderEvent";
import Matrix from "../../../geom/Matrix";
import Point from "../../../geom/Point";
import Rectangle from "../../../geom/Rectangle";
import Video from "../../../media/Video";
import AntiAliasType from "../../../text/AntiAliasType";
import GridFitType from "../../../text/GridFitType";
import TextField from "../../../text/TextField";
import TextFieldType from "../../../text/TextFieldType";
import ColorTransform from "../../../geom/ColorTransform";
import HTMLParser from "../../formats/html/HTMLParser";
import * as internal from "../../utils/InternalAccess";
import DisplayObjectRendererType from "../DisplayObjectRendererType";
import DisplayObjectType from "../DisplayObjectType";
import CanvasBitmap from "./CanvasBitmap";
import CanvasDisplayObject from "./CanvasDisplayObject";
import CanvasGraphics from "./CanvasGraphics";
import CanvasTextField from "./CanvasTextField";
import CanvasTilemap from "./CanvasTilemap";
import CanvasVideo from "./CanvasVideo";

export default class CanvasRenderer extends CanvasRendererAPI
{
	public __colorTransform: ColorTransform;
	public __domRenderer: DOMRenderer;
	public __transform: Matrix;

	public constructor(context: CanvasRenderingContext2D)
	{
		super(context);

		this.__colorTransform = new ColorTransform();
		this.__transform = new Matrix();

		this.__type = DisplayObjectRendererType.CANVAS;
	}

	public applySmoothing(context: CanvasRenderingContext2D, value: boolean): void
	{
		context.imageSmoothingEnabled = value;
	}

	public setTransform(transform: Matrix, context: CanvasRenderingContext2D = null): void
	{
		if (context == null)
		{
			context = this.context;
		}
		else if (this.context == context && this.__worldTransform != null)
		{
			this.__transform.copyFrom(transform);
			this.__transform.concat(this.__worldTransform);
			transform = this.__transform;
		}

		if (this.__roundPixels)
		{
			context.setTransform(transform.a, transform.b, transform.c, transform.d, Math.round(transform.tx), Math.round(transform.ty));
		}
		else
		{
			context.setTransform(transform.a, transform.b, transform.c, transform.d, transform.tx, transform.ty);
		}
	}

	public __clear(): void
	{
		if (this.__stage != null)
		{
			var cacheBlendMode = this.__blendMode;
			this.__blendMode = null;
			this.__setBlendMode(BlendMode.NORMAL);

			this.context.setTransform(1, 0, 0, 1, 0, 0);
			this.context.globalAlpha = 1;

			if (!(<internal.Stage><any>this.__stage).__transparent && (<internal.Stage><any>this.__stage).__clearBeforeRender)
			{
				this.context.fillStyle = (<internal.Stage><any>this.__stage).__colorString;
				this.context.fillRect(0, 0, this.__stage.stageWidth * (<internal.Stage><any>this.__stage).__contentsScaleFactor, this.__stage.stageHeight * (<internal.Stage><any>this.__stage).__contentsScaleFactor);
			}
			else if ((<internal.Stage><any>this.__stage).__transparent && (<internal.Stage><any>this.__stage).__clearBeforeRender)
			{
				this.context.clearRect(0, 0, this.__stage.stageWidth * (<internal.Stage><any>this.__stage).__contentsScaleFactor, this.__stage.stageHeight * (<internal.Stage><any>this.__stage).__contentsScaleFactor);
			}

			this.__setBlendMode(cacheBlendMode);
		}
	}

	public __drawBitmapData(bitmapData: BitmapData, source: IBitmapDrawable, clipRect: Rectangle): void
	{
		var clipMatrix = null;

		if (clipRect != null)
		{
			clipMatrix = (<internal.Matrix><any>Matrix).__pool.get();
			clipMatrix.copyFrom(this.__worldTransform);
			clipMatrix.invert();
			this.__pushMaskRect(clipRect, clipMatrix);
		}

		var context = (<internal.BitmapData><any>bitmapData).__getCanvasContext(true);

		if (!this.__allowSmoothing) this.applySmoothing(context, false);

		this.__render(source);

		if (!this.__allowSmoothing) this.applySmoothing(context, true);

		context.setTransform(1, 0, 0, 1, 0, 0);
		// buffer.__srcImageData = null;
		// buffer.data = null;

		(<internal.BitmapData><any>bitmapData).__setDirty();

		if (clipRect != null)
		{
			this.__popMaskRect();
			(<internal.Matrix><any>Matrix).__pool.release(clipMatrix);
		}
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

	public __popMask(): void
	{
		this.context.restore();
	}

	public __popMaskObject(object: DisplayObject, handleScrollRect: boolean = true): void
	{
		if (!(<internal.DisplayObject><any>object).__renderData.isCacheBitmapRender && (<internal.DisplayObject><any>object).__mask != null)
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
		this.context.restore();
	}

	public __pushMask(mask: DisplayObject): void
	{
		this.context.save();

		this.setTransform((<internal.DisplayObject><any>mask).__renderTransform, this.context);

		this.context.beginPath();
		this.__renderMask(mask);
		this.context.closePath();

		this.context.clip();
	}

	public __pushMaskObject(object: DisplayObject, handleScrollRect: boolean = true): void
	{
		if (handleScrollRect && (<internal.DisplayObject><any>object).__scrollRect != null)
		{
			this.__pushMaskRect((<internal.DisplayObject><any>object).__scrollRect, (<internal.DisplayObject><any>object).__renderTransform);
		}

		if (!(<internal.DisplayObject><any>object).__renderData.isCacheBitmapRender && (<internal.DisplayObject><any>object).__mask != null)
		{
			this.__pushMask((<internal.DisplayObject><any>object).__mask);
		}
	}

	public __pushMaskRect(rect: Rectangle, transform: Matrix): void
	{
		this.context.save();

		this.setTransform(transform, this.context);

		this.context.beginPath();
		this.context.rect(rect.x, rect.y, rect.width, rect.height);
		this.context.clip();
	}

	public __render(object: IBitmapDrawable): void
	{
		if (object != null)
		{
			if ((<internal.IBitmapDrawable><any>object).__type != null)
			{
				this.__renderDisplayObject(object as DisplayObject);
			}
			else
			{
				this.__renderBitmapData(object as BitmapData);
			}
		}
	}

	public __renderBitmap(bitmap: Bitmap): void
	{
		this.__updateCacheBitmap(bitmap, /*!this.__worldColorTransform.__isDefault ()*/ false);

		if (bitmap.bitmapData != null && (<internal.BitmapData><any>bitmap.bitmapData).__getCanvas() != null)
		{
			(<internal.Bitmap><any>bitmap).__imageVersion = (<internal.BitmapData><any>bitmap.bitmapData).__getVersion();
		}

		if ((<internal.DisplayObject><any>bitmap).__renderData.cacheBitmap != null && !(<internal.DisplayObject><any>bitmap).__renderData.isCacheBitmapRender)
		{
			CanvasBitmap.render((<internal.DisplayObject><any>bitmap).__renderData.cacheBitmap, this);
		}
		else
		{
			CanvasDisplayObject.render(bitmap, this);
			CanvasBitmap.render(bitmap, this);
		}
	}

	public __renderBitmapData(bitmapData: BitmapData): void
	{
		if (!bitmapData.readable) return;

		this.context.globalAlpha = 1;

		this.setTransform((<internal.BitmapData><any>bitmapData).__renderTransform, this.context);

		this.context.drawImage((<internal.BitmapData><any>bitmapData).__getElement(), 0, 0, bitmapData.width, bitmapData.height);
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
			}

			if ((<internal.DisplayObject><any>object).__customRenderEvent != null)
			{
				var event = (<internal.DisplayObject><any>object).__customRenderEvent;
				event.allowSmoothing = this.__allowSmoothing;
				event.objectMatrix.copyFrom((<internal.DisplayObject><any>object).__renderTransform);
				(<internal.ColorTransform><any>event.objectColorTransform).__copyFrom((<internal.DisplayObject><any>object).__worldColorTransform);
				(<internal.RenderEvent><any>event).__renderer = this;
				(<internal.Event><any>event).__type = RenderEvent.RENDER_CANVAS;

				this.__setBlendMode((<internal.DisplayObject><any>object).__worldBlendMode);
				this.__pushMaskObject(object);

				object.dispatchEvent(event);

				this.__popMaskObject(object);
			}
		}
	}

	public __renderDisplayObjectContainer(container: DisplayObjectContainer): void
	{
		if (this.__domRenderer == null) (<internal.DisplayObjectContainer><any>container).__cleanupRemovedChildren();

		if (!(<internal.DisplayObject><any>container).__renderable
			|| (<internal.DisplayObject><any>container).__worldAlpha <= 0
			|| (container.mask != null && (container.mask.width <= 0 || container.mask.height <= 0))) return;

		this.__updateCacheBitmap(container, /*!this.__worldColorTransform.__isDefault ()*/ false);

		if ((<internal.DisplayObject><any>container).__renderData.cacheBitmap != null && !(<internal.DisplayObject><any>container).__renderData.isCacheBitmapRender)
		{
			CanvasBitmap.render((<internal.DisplayObject><any>container).__renderData.cacheBitmap, this);
		}
		else
		{
			CanvasDisplayObject.render(container, this);
		}

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

	public __renderMask(mask: DisplayObject): void
	{
		if (mask != null)
		{
			switch ((<internal.DisplayObject><any>mask).__type)
			{
				case DisplayObjectType.BITMAP:
					this.context.rect(0, 0, mask.width, mask.height);
					break;

				case DisplayObjectType.DISPLAY_OBJECT_CONTAINER:
				case DisplayObjectType.MOVIE_CLIP:
					var container: DisplayObjectContainer = mask as DisplayObjectContainer;
					if (this.__domRenderer == null) (<internal.DisplayObjectContainer><any>container).__cleanupRemovedChildren();

					if ((<internal.DisplayObject><any>container).__graphics != null)
					{
						CanvasGraphics.renderMask((<internal.DisplayObject><any>container).__graphics, this);
					}

					var child = (<internal.DisplayObject><any>container).__firstChild;
					while (child != null)
					{
						this.__renderMask(child);
						child = (<internal.DisplayObject><any>child).__nextSibling;
					}
					break;

				case DisplayObjectType.DOM_ELEMENT:
					break;

				case DisplayObjectType.SIMPLE_BUTTON:
					var button: SimpleButton = mask as SimpleButton;
					this.__renderMask((<internal.SimpleButton><any>button).__currentState);
					break;

				default:
					if ((<internal.DisplayObject><any>mask).__graphics != null)
					{
						CanvasGraphics.renderMask((<internal.DisplayObject><any>mask).__graphics, this);
					}
					break;
			}
		}
	}

	public __renderShape(shape: DisplayObject): void
	{
		if (shape.mask == null || (shape.mask.width > 0 && shape.mask.height > 0))
		{
			this.__updateCacheBitmap(shape, /*!this.__worldColorTransform.__isDefault ()*/ false);

			if ((<internal.DisplayObject><any>shape).__renderData.cacheBitmap != null && !(<internal.DisplayObject><any>shape).__renderData.isCacheBitmapRender)
			{
				CanvasBitmap.render((<internal.DisplayObject><any>shape).__renderData.cacheBitmap, this);
			}
			else
			{
				CanvasDisplayObject.render(shape, this);
			}
		}
	}

	public __renderSimpleButton(button: SimpleButton): void
	{
		if (!(<internal.DisplayObject><any>button).__renderable || (<internal.DisplayObject><any>button).__worldAlpha <= 0 || (<internal.SimpleButton><any>button).__currentState == null) return;

		this.__pushMaskObject(button);
		this.__renderDisplayObject((<internal.SimpleButton><any>button).__currentState);
		this.__popMaskObject(button);
	}

	public __renderTextField(textField: TextField): void
	{
		// TODO: Better DOM workaround on cacheAsBitmap

		if (this.__domRenderer != null && !(<internal.TextField><any>textField).__renderedOnCanvasWhileOnDOM)
		{
			(<internal.TextField><any>textField).__renderedOnCanvasWhileOnDOM = true;

			if (textField.type == TextFieldType.INPUT)
			{
				textField.replaceText(0, (<internal.TextField><any>textField).__text.length, (<internal.TextField><any>textField).__text);
			}

			if ((<internal.TextField><any>textField).__isHTML)
			{
				(<internal.TextField><any>textField).__updateText(HTMLParser.parse((<internal.TextField><any>textField).__text, (<internal.TextField><any>textField).__textFormat, (<internal.TextField><any>textField).__textEngine.textFormatRanges));
			}

			(<internal.TextField><any>textField).__dirty = true;
			(<internal.TextField><any>textField).__layoutDirty = true;
			(<internal.TextField><any>textField).__setRenderDirty();
		}

		if (textField.mask == null || (textField.mask.width > 0 && textField.mask.height > 0))
		{
			this.__updateCacheBitmap(textField, (<internal.TextField><any>textField).__dirty);

			if ((<internal.DisplayObject><any>textField).__renderData.cacheBitmap != null && !(<internal.DisplayObject><any>textField).__renderData.isCacheBitmapRender)
			{
				CanvasBitmap.render((<internal.DisplayObject><any>textField).__renderData.cacheBitmap, this);
			}
			else
			{
				CanvasTextField.render(textField, this, (<internal.DisplayObject><any>textField).__worldTransform);

				var smoothingEnabled = false;

				if ((<internal.TextField><any>textField).__textEngine.antiAliasType == AntiAliasType.ADVANCED && (<internal.TextField><any>textField).__textEngine.gridFitType == GridFitType.PIXEL)
				{
					smoothingEnabled = this.context.imageSmoothingEnabled;

					if (smoothingEnabled)
					{
						this.context.imageSmoothingEnabled = false;
					}
				}

				CanvasDisplayObject.render(textField, this);

				if (smoothingEnabled)
				{
					this.context.imageSmoothingEnabled = true;
				}
			}
		}
	}

	public __renderTilemap(tilemap: Tilemap): void
	{
		this.__updateCacheBitmap(tilemap, /*!this.__worldColorTransform.__isDefault ()*/ false);

		if ((<internal.DisplayObject><any>tilemap).__renderData.cacheBitmap != null && !(<internal.DisplayObject><any>tilemap).__renderData.isCacheBitmapRender)
		{
			CanvasBitmap.render((<internal.DisplayObject><any>tilemap).__renderData.cacheBitmap, this);
		}
		else
		{
			CanvasDisplayObject.render(tilemap, this);
			CanvasTilemap.render(tilemap, this);
		}
	}

	public __renderVideo(video: Video): void
	{
		CanvasVideo.render(video, this);
	}

	public __setBlendMode(value: BlendMode): void
	{
		if (this.__overrideBlendMode != null) value = this.__overrideBlendMode;
		if (this.__blendMode == value) return;

		this.__blendMode = value;
		this.__setBlendModeContext(this.context, value);
	}

	public __setBlendModeContext(context: CanvasRenderingContext2D, value: BlendMode): void
	{
		switch (value)
		{
			case BlendMode.ADD:
				this.context.globalCompositeOperation = "lighter";
				break;

			// case ALPHA:

			// 	context.globalCompositeOperation = "";

			case BlendMode.DARKEN:
				this.context.globalCompositeOperation = "darken";
				break;

			case BlendMode.DIFFERENCE:
				this.context.globalCompositeOperation = "difference";
				break;

			// case ERASE:

			// context.globalCompositeOperation = "";

			case BlendMode.HARDLIGHT:
				this.context.globalCompositeOperation = "hard-light";
				break;

			// case INVERT:

			// context.globalCompositeOperation = "";

			// case LAYER:

			// 	context.globalCompositeOperation = "source-over";

			case BlendMode.LIGHTEN:
				this.context.globalCompositeOperation = "lighten";
				break;

			case BlendMode.MULTIPLY:
				this.context.globalCompositeOperation = "multiply";
				break;

			case BlendMode.OVERLAY:
				this.context.globalCompositeOperation = "overlay";
				break;

			case BlendMode.SCREEN:
				this.context.globalCompositeOperation = "screen";
				break;

			// case SHADER:

			// context.globalCompositeOperation = "";

			// case SUBTRACT:

			// context.globalCompositeOperation = "";

			default:
				this.context.globalCompositeOperation = "source-over";
				break;
		}
	}

	public __updateCacheBitmap(object: DisplayObject, force: boolean): boolean
	{
		// #if openfl_disable_cacheasbitmap
		// return false;
		// #end

		var renderData = (<internal.DisplayObject><any>object).__renderData;

		if (renderData.isCacheBitmapRender) return false;
		var updated = false;

		if (object.cacheAsBitmap
			|| !(<internal.ColorTransform><any>(<internal.DisplayObject><any>object).__worldColorTransform).__isDefault(true)
			|| (this.__worldColorTransform != null && !(<internal.ColorTransform><any>this.__worldColorTransform).__isDefault(true)))
		{
			if (renderData.cacheBitmapMatrix == null)
			{
				renderData.cacheBitmapMatrix = new Matrix();
			}

			var hasFilters = (<internal.DisplayObject><any>object).__filters != null;
			var bitmapMatrix = ((<internal.DisplayObject><any>object).__cacheAsBitmapMatrix != null ? (<internal.DisplayObject><any>object).__cacheAsBitmapMatrix : (<internal.DisplayObject><any>object).__renderTransform);

			var rect = null;

			var colorTransform = (<internal.ColorTransform><any>ColorTransform).__pool.get();
			(<internal.ColorTransform><any>colorTransform).__copyFrom((<internal.DisplayObject><any>object).__worldColorTransform);
			if (this.__worldColorTransform != null) (<internal.ColorTransform><any>colorTransform).__combine(this.__worldColorTransform);

			var needRender = (renderData.cacheBitmap == null
				|| ((<internal.DisplayObject><any>object).__renderDirty && (force || (<internal.DisplayObject><any>object).__firstChild != null))
				|| object.opaqueBackground != renderData.cacheBitmapBackground)
				|| ((<internal.DisplayObject><any>object).__graphics != null && (<internal.Graphics><any>(<internal.DisplayObject><any>object).__graphics).__softwareDirty)
				|| !(<internal.ColorTransform><any>renderData.cacheBitmapColorTransform).__equals(colorTransform, true);

			if (!needRender
				&& (bitmapMatrix.a != renderData.cacheBitmapMatrix.a
					|| bitmapMatrix.b != renderData.cacheBitmapMatrix.b
					|| bitmapMatrix.c != renderData.cacheBitmapMatrix.c
					|| bitmapMatrix.d != renderData.cacheBitmapMatrix.d))
			{
				needRender = true;
			}

			if (hasFilters && !needRender)
			{
				for (let filter of (<internal.DisplayObject><any>object).__filters)
				{
					if ((<internal.BitmapFilter><any>filter).__renderDirty)
					{
						needRender = true;
						break;
					}
				}
			}

			if (!needRender
				&& renderData.cacheBitmapData != null
				&& (<internal.BitmapData><any>renderData.cacheBitmapData).__getCanvas() != null
				&& (<internal.BitmapData><any>renderData.cacheBitmapData).__getVersion() < (<internal.BitmapData><any>renderData.cacheBitmapData).__renderData.textureVersion)
			{
				needRender = true;
			}

			// TODO: Handle renderTransform (for scrollRect, displayMatrix changes, etc)
			var updateTransform = (needRender || !(<internal.DisplayObject><any>renderData.cacheBitmap).__worldTransform.equals((<internal.DisplayObject><any>object).__worldTransform));

			renderData.cacheBitmapMatrix.copyFrom(bitmapMatrix);
			renderData.cacheBitmapMatrix.tx = 0;
			renderData.cacheBitmapMatrix.ty = 0;

			// TODO: Handle dimensions better if object has a scrollRect?

			var bitmapWidth = 0, bitmapHeight = 0;
			var filterWidth = 0, filterHeight = 0;
			var offsetX = 0., offsetY = 0.;

			if (updateTransform)
			{
				rect = (<internal.Rectangle><any>Rectangle).__pool.get();

				(<internal.DisplayObject><any>object).__getFilterBounds(rect, renderData.cacheBitmapMatrix);

				filterWidth = Math.ceil(rect.width);
				filterHeight = Math.ceil(rect.height);

				offsetX = rect.x > 0 ? Math.ceil(rect.x) : Math.floor(rect.x);
				offsetY = rect.y > 0 ? Math.ceil(rect.y) : Math.floor(rect.y);

				if (renderData.cacheBitmapData != null)
				{
					if (filterWidth > renderData.cacheBitmapData.width
						|| filterHeight > renderData.cacheBitmapData.height)
					{
						bitmapWidth = Math.ceil(Math.max(filterWidth * 1.25, renderData.cacheBitmapData.width));
						bitmapHeight = Math.ceil(Math.max(filterHeight * 1.25, renderData.cacheBitmapData.height));
						needRender = true;
					}
					else
					{
						bitmapWidth = renderData.cacheBitmapData.width;
						bitmapHeight = renderData.cacheBitmapData.height;
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
				renderData.cacheBitmapBackground = object.opaqueBackground;

				if (filterWidth >= 0.5 && filterHeight >= 0.5)
				{
					var needsFill = (object.opaqueBackground != null && (bitmapWidth != filterWidth || bitmapHeight != filterHeight));
					var fillColor = object.opaqueBackground != null ? (0xFF << 24) | object.opaqueBackground : 0;
					var bitmapColor = needsFill ? 0 : fillColor;

					if (renderData.cacheBitmapData == null
						|| bitmapWidth > renderData.cacheBitmapData.width
						|| bitmapHeight > renderData.cacheBitmapData.height)
					{
						renderData.cacheBitmapData = new BitmapData(bitmapWidth, bitmapHeight, true, bitmapColor);

						if (renderData.cacheBitmap == null) renderData.cacheBitmap = new Bitmap();
						(<internal.Bitmap><any>renderData.cacheBitmap).__bitmapData = renderData.cacheBitmapData;
						renderData.cacheBitmapRendererSW = null;
					}
					else
					{
						renderData.cacheBitmapData.fillRect(renderData.cacheBitmapData.rect, bitmapColor);
					}

					if (needsFill)
					{
						rect.setTo(0, 0, filterWidth, filterHeight);
						renderData.cacheBitmapData.fillRect(rect, fillColor);
					}
				}
				else
				{
					(<internal.ColorTransform><any>ColorTransform).__pool.release(colorTransform);

					if (this.__domRenderer != null && renderData.cacheBitmap != null)
					{
						(<internal.DOMRenderer><any>this.__domRenderer).__clearBitmap(renderData.cacheBitmap);
					}

					renderData.cacheBitmap = null;
					renderData.cacheBitmapData = null;
					renderData.cacheBitmapData2 = null;
					renderData.cacheBitmapData3 = null;
					renderData.cacheBitmapRendererSW = null;

					return true;
				}
			}
			else
			{
				// Should we retain these longer?

				renderData.cacheBitmapData = renderData.cacheBitmap.bitmapData;
				renderData.cacheBitmapData2 = null;
				renderData.cacheBitmapData3 = null;
			}

			if (updateTransform)
			{
				(<internal.DisplayObject><any>renderData.cacheBitmap).__worldTransform.copyFrom((<internal.DisplayObject><any>object).__worldTransform);

				if (bitmapMatrix == (<internal.DisplayObject><any>object).__renderTransform)
				{
					(<internal.DisplayObject><any>renderData.cacheBitmap).__renderTransform.identity();
					(<internal.DisplayObject><any>renderData.cacheBitmap).__renderTransform.tx = (<internal.DisplayObject><any>object).__renderTransform.tx + offsetX;
					(<internal.DisplayObject><any>renderData.cacheBitmap).__renderTransform.ty = (<internal.DisplayObject><any>object).__renderTransform.ty + offsetY;
				}
				else
				{
					(<internal.DisplayObject><any>renderData.cacheBitmap).__renderTransform.copyFrom(renderData.cacheBitmapMatrix);
					(<internal.DisplayObject><any>renderData.cacheBitmap).__renderTransform.invert();
					(<internal.DisplayObject><any>renderData.cacheBitmap).__renderTransform.concat((<internal.DisplayObject><any>object).__renderTransform);
					(<internal.DisplayObject><any>renderData.cacheBitmap).__renderTransform.tx += offsetX;
					(<internal.DisplayObject><any>renderData.cacheBitmap).__renderTransform.ty += offsetY;
				}
			}

			renderData.cacheBitmap.smoothing = this.__allowSmoothing;
			(<internal.DisplayObject><any>renderData.cacheBitmap).__renderable = (<internal.DisplayObject><any>object).__renderable;
			(<internal.DisplayObject><any>renderData.cacheBitmap).__worldAlpha = (<internal.DisplayObject><any>object).__worldAlpha;
			(<internal.DisplayObject><any>renderData.cacheBitmap).__worldBlendMode = (<internal.DisplayObject><any>object).__worldBlendMode;
			(<internal.DisplayObject><any>renderData.cacheBitmap).__worldShader = (<internal.DisplayObject><any>object).__worldShader;
			renderData.cacheBitmap.mask = (<internal.DisplayObject><any>object).__mask;

			if (needRender)
			{
				if (renderData.cacheBitmapRendererSW == null || (<internal.DisplayObjectRenderer><any>renderData.cacheBitmapRendererSW).__type != DisplayObjectRendererType.CANVAS)
				{
					if ((<internal.BitmapData><any>renderData.cacheBitmapData).__getCanvas() == null)
					{
						var color = object.opaqueBackground != null ? (0xFF << 24) | object.opaqueBackground : 0;
						renderData.cacheBitmapData = new BitmapData(bitmapWidth, bitmapHeight, true, color);
						(<internal.Bitmap><any>renderData.cacheBitmap).__bitmapData = renderData.cacheBitmapData;
					}

					renderData.cacheBitmapRendererSW = new CanvasRenderer((<internal.BitmapData><any>renderData.cacheBitmapData).__getCanvasContext());
					(<internal.DisplayObjectRenderer><any>renderData.cacheBitmapRendererSW).__worldTransform = new Matrix();
					(<internal.DisplayObjectRenderer><any>renderData.cacheBitmapRendererSW).__worldColorTransform = new ColorTransform();
				}

				if (renderData.cacheBitmapColorTransform == null) renderData.cacheBitmapColorTransform = new ColorTransform();

				(<internal.DisplayObjectRenderer><any>renderData.cacheBitmapRendererSW).__stage = object.stage;

				(<internal.DisplayObjectRenderer><any>renderData.cacheBitmapRendererSW).__allowSmoothing = this.__allowSmoothing;
				(renderData.cacheBitmapRendererSW as CanvasRenderer).__setBlendMode(BlendMode.NORMAL);
				(<internal.DisplayObjectRenderer><any>renderData.cacheBitmapRendererSW).__worldAlpha = 1 / (<internal.DisplayObject><any>object).__worldAlpha;

				(<internal.DisplayObjectRenderer><any>renderData.cacheBitmapRendererSW).__worldTransform.copyFrom((<internal.DisplayObject><any>object).__renderTransform);
				(<internal.DisplayObjectRenderer><any>renderData.cacheBitmapRendererSW).__worldTransform.invert();
				(<internal.DisplayObjectRenderer><any>renderData.cacheBitmapRendererSW).__worldTransform.concat(renderData.cacheBitmapMatrix);
				(<internal.DisplayObjectRenderer><any>renderData.cacheBitmapRendererSW).__worldTransform.tx -= offsetX;
				(<internal.DisplayObjectRenderer><any>renderData.cacheBitmapRendererSW).__worldTransform.ty -= offsetY;

				(<internal.ColorTransform><any>(<internal.DisplayObjectRenderer><any>renderData.cacheBitmapRendererSW).__worldColorTransform).__copyFrom(colorTransform);
				(<internal.ColorTransform><any>(<internal.DisplayObjectRenderer><any>renderData.cacheBitmapRendererSW).__worldColorTransform).__invert();

				renderData.isCacheBitmapRender = true;

				(<internal.DisplayObjectRenderer><any>renderData.cacheBitmapRendererSW).__drawBitmapData(renderData.cacheBitmapData, object, null);

				if (hasFilters)
				{
					var needSecondBitmapData = false;
					var needCopyOfOriginal = false;

					for (let filter of (<internal.DisplayObject><any>object).__filters)
					{
						if ((<internal.BitmapFilter><any>filter).__needSecondBitmapData)
						{
							needSecondBitmapData = true;
						}
						if ((<internal.BitmapFilter><any>filter).__preserveObject)
						{
							needCopyOfOriginal = true;
						}
					}

					var bitmap = renderData.cacheBitmapData;
					var bitmap2 = null;
					var bitmap3 = null;

					if (needSecondBitmapData)
					{
						if (renderData.cacheBitmapData2 == null
							|| (<internal.BitmapData><any>renderData.cacheBitmapData2).__getCanvas() == null
							|| bitmapWidth > renderData.cacheBitmapData2.width
							|| bitmapHeight > renderData.cacheBitmapData2.height)
						{
							renderData.cacheBitmapData2 = new BitmapData(bitmapWidth, bitmapHeight, true, 0);
						}
						else
						{
							renderData.cacheBitmapData2.fillRect(renderData.cacheBitmapData2.rect, 0);
						}
						bitmap2 = renderData.cacheBitmapData2;
					}
					else
					{
						bitmap2 = bitmap;
					}

					if (needCopyOfOriginal)
					{
						if (renderData.cacheBitmapData3 == null
							|| (<internal.BitmapData><any>renderData.cacheBitmapData3).__getCanvas() == null
							|| bitmapWidth > renderData.cacheBitmapData3.width
							|| bitmapHeight > renderData.cacheBitmapData3.height)
						{
							renderData.cacheBitmapData3 = new BitmapData(bitmapWidth, bitmapHeight, true, 0);
						}
						else
						{
							renderData.cacheBitmapData3.fillRect(renderData.cacheBitmapData3.rect, 0);
						}
						bitmap3 = renderData.cacheBitmapData3;
					}

					if ((<internal.DisplayObject><any>object).__tempPoint == null) (<internal.DisplayObject><any>object).__tempPoint = new Point();
					var destPoint = (<internal.DisplayObject><any>object).__tempPoint;
					var cacheBitmap, lastBitmap;

					for (let filter of (<internal.DisplayObject><any>object).__filters)
					{
						if ((<internal.BitmapFilter><any>filter).__preserveObject)
						{
							bitmap3.copyPixels(bitmap, bitmap.rect, destPoint);
						}

						lastBitmap = (<internal.BitmapFilter><any>filter).__applyFilter(bitmap2, bitmap, bitmap.rect, destPoint);

						if ((<internal.BitmapFilter><any>filter).__preserveObject)
						{
							lastBitmap.draw(bitmap3, null, (<internal.DisplayObject><any>object).__objectTransform != null ? (<internal.DisplayObject><any>object).__objectTransform.colorTransform : null);
						}
						(<internal.BitmapFilter><any>filter).__renderDirty = false;

						if (needSecondBitmapData && lastBitmap == bitmap2)
						{
							cacheBitmap = bitmap;
							bitmap = bitmap2;
							bitmap2 = cacheBitmap;
						}
					}

					if (renderData.cacheBitmapData != bitmap)
					{
						// TODO: Fix issue with swapping this.__renderData.cacheBitmap.__bitmapData
						// this.__renderData.cacheBitmapData.copyPixels (bitmap, bitmap.rect, destPoint);

						// Adding this.__renderData.cacheBitmapRendererSW = null; makes this work
						cacheBitmap = renderData.cacheBitmapData;
						renderData.cacheBitmapData = bitmap;
						renderData.cacheBitmapData2 = cacheBitmap;
						(<internal.Bitmap><any>renderData.cacheBitmap).__bitmapData = renderData.cacheBitmapData;
						renderData.cacheBitmapRendererSW = null;
					}

					(<internal.Bitmap><any>renderData.cacheBitmap).__imageVersion = (<internal.BitmapData><any>renderData.cacheBitmapData).__renderData.textureVersion;
				}

				(<internal.ColorTransform><any>renderData.cacheBitmapColorTransform).__copyFrom(colorTransform);

				if (!(<internal.ColorTransform><any>renderData.cacheBitmapColorTransform).__isDefault(true))
				{
					renderData.cacheBitmapColorTransform.alphaMultiplier = 1;
					renderData.cacheBitmapData.colorTransform(renderData.cacheBitmapData.rect,
						renderData.cacheBitmapColorTransform);
				}

				renderData.isCacheBitmapRender = false;
			}

			if (updateTransform)
			{
				(<internal.Rectangle><any>Rectangle).__pool.release(rect);
			}

			updated = updateTransform;

			(<internal.ColorTransform><any>ColorTransform).__pool.release(colorTransform);
		}
		else if (renderData.cacheBitmap != null)
		{
			if (this.__domRenderer != null && renderData.cacheBitmap != null)
			{
				(<internal.DOMRenderer><any>this.__domRenderer).__clearBitmap(renderData.cacheBitmap);
			}

			renderData.cacheBitmap = null;
			renderData.cacheBitmapData = null;
			renderData.cacheBitmapData2 = null;
			renderData.cacheBitmapData3 = null;
			renderData.cacheBitmapColorTransform = null;
			renderData.cacheBitmapRendererSW = null;

			updated = true;
		}

		return updated;
	}
}
