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
import lime.graphics.cairo.CairoContent;
import lime.graphics.cairo.CairoExtend;
import lime.graphics.cairo.CairoFilter;
import lime.graphics.cairo.CairoFormat;
import lime.graphics.cairo.CairoImageSurface;
import lime.graphics.cairo.CairoOperator;
import lime.graphics.cairo.CairoPattern;
import lime.graphics.cairo.CairoSurface;
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
@:access(openfl.display.Bitmap)
@:access(openfl.display.BitmapData)
@:access(openfl.display.DisplayObject)
@:access(openfl.display.Graphics)
@:access(openfl.display.IBitmapDrawable)
@:access(openfl.display.Stage)
@:access(openfl.display.Stage3D)
@:allow(openfl.display._internal)
@:allow(openfl.display)
@:access(openfl.geom.Matrix)
@:access(openfl.geom.Rectangle)
class CairoRenderer extends DisplayObjectRenderer
{
	/**
		The current Cairo render context
	**/
	@SuppressWarnings("checkstyle:Dynamic")
	public var cairo:#if lime CairoRenderContext #else Dynamic #end;

	@:noCompletion private var __matrix:Matrix;
	@SuppressWarnings("checkstyle:Dynamic") @:noCompletion private var __matrix3:#if lime Matrix3 #else Dynamic #end;
	#if lime
	// the current group's touched buffer (see __touch), once built: a bitmap per layer depth, in the
	// group bitmap's coordinates
	@:noCompletion private var __touched:Cairo;
	@:noCompletion private var __touchedBitmap:BitmapData;
	@:noCompletion private var __touchedWidth:Int;
	@:noCompletion private var __touchedHeight:Int;

	@:noCompletion private static var __touchedBitmaps:Array<BitmapData> = [];

	// the bitmap being drawn into when it is ours (a group's, a cache bitmap, a BitmapData.draw
	// bitmap), null on the window; and the group bitmaps, one per layer depth
	@:noCompletion private var __targetBitmap:BitmapData;

	@:noCompletion private static var __groupBitmaps:Array<BitmapData> = [];
	// the mask of __writeAlphaBytes, and the copy of the window __compositeFormulaOnViews works on
	@:noCompletion private static var __alphaBytesMask:CairoPattern;
	@:noCompletion private static var __windowCopy:BitmapData;

	// the alpha of the current SUBTRACT/INVERT run, its rectangle, and one plane per layer depth
	// (see __compositeFormulaOnViews)
	@:noCompletion private var __alphaPlane:Cairo;
	@:noCompletion private var __alphaPlaneRect:Rectangle;

	@:noCompletion private static var __alphaPlanes:Array<CairoImageSurface> = [];
	#end

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
		__resetBufferLevel();

		// the root is rendered as it is (see __renderRoot), unless BitmapData.draw gave a blend mode:
		// then the root is composited with it, as one object
		if (__overrideBlendMode != null && __overrideBlendMode != NORMAL) __renderDrawable(object);
		else
			__renderRoot(object);
		#if lime
		if (__alphaPlane != null) __mergeAlphaPlane();
		#end
	}

	#if lime
	/**
		Whether `object` is a SUBTRACT or INVERT object on a transparent target, which continues the
		current run of them (see `__compositeFormulaOnViews`).
	**/
	@:noCompletion private function __continuesFormulaRun(object:IBitmapDrawable):Bool
	{
		if (object.__drawableType == BITMAP_DATA || __backdropIsOpaque()) return false;
		var displayObject:DisplayObject = cast object;
		if (displayObject.__blendMode == LAYER && (__overrideBlendMode == null || __overrideBlendMode == NORMAL)) return false;
		var blendMode = __effectiveBlendMode(displayObject);
		return blendMode == SUBTRACT || blendMode == INVERT;
	}
	#end

	/**
		Renders the root of a render. Its own blend mode is for whoever composites the result: the
		renderer that draws a cache bitmap applies it to the bitmap, and `BitmapData.draw` ignores it,
		as Flash does. Applied inside the render, against a transparent target, MULTIPLY, SUBTRACT,
		ERASE and ALPHA would leave a cache bitmap empty. So the root's mode counts as the group's mode
		here, as inside any group: the root and the children that only inherit its mode draw NORMAL
		(see `__effectiveBlendMode`). A blend mode given to `BitmapData.draw` replaces the root's own
		and is left as it is.
	**/
	@:noCompletion private function __renderRoot(object:IBitmapDrawable):Void
	{
		var groupBlendMode = __groupBlendMode;
		if (object.__drawableType != BITMAP_DATA && __overrideBlendMode == null)
		{
			var displayObject:DisplayObject = cast object;
			__groupBlendMode = displayObject.__worldBlendMode;
		}
		__renderDrawableDirect(object);
		__groupBlendMode = groupBlendMode;
	}

	@:noCompletion private function __renderDrawable(object:IBitmapDrawable):Void
	{
		if (object == null) return;

		#if lime
		// a run of SUBTRACT/INVERT objects keeps the target's alpha in a plane of its own; anything
		// else drawn into the target needs the alpha bytes back first (see __mergeAlphaPlane)
		if (__alphaPlane != null && !__continuesFormulaRun(object)) __mergeAlphaPlane();

		if (object.__drawableType != BITMAP_DATA)
		{
			var displayObject:DisplayObject = cast object;
			if (displayObject.__blendMode == LAYER && (__overrideBlendMode == null || __overrideBlendMode == NORMAL))
			{
				__renderGroup(object);
				__touch(displayObject, true);
				return;
			}
			var blendMode = __effectiveBlendMode(displayObject);
			if (blendMode == SUBTRACT || blendMode == INVERT || blendMode == ERASE || blendMode == ALPHA)
			{
				// a cutter is not drawn straight on the stage (see __drawsOntoStage)
				if ((blendMode == ERASE || blendMode == ALPHA) && __drawsOntoStage()) return;
				__renderFormulaGroup(object, blendMode);
				__touch(displayObject, true);
				return;
			}
			if (__needsWholeObjectGroup(displayObject, blendMode))
			{
				__renderGroup(object, blendMode);
				__touch(displayObject, true);
				return;
			}
		}
		#end

		__renderDrawableDirect(object);
		#if lime
		if (object.__drawableType != BITMAP_DATA) __touch(cast object);
		#end
	}

	#if lime
	/**
		Whether a container has to be rendered into a group before it is blended.

		Flash blends an object as a whole. If a container were drawn child by child with one of the
		modes this renderer blends in a single operation (ADD, MULTIPLY, SCREEN, DIFFERENCE, LIGHTEN,
		DARKEN, HARDLIGHT or OVERLAY), each child would be blended separately, and where two children
		overlap the backdrop would be blended twice. So a container with more than one piece, either
		several children or a child plus graphics of its own, is rendered into a group first, with
		children that only inherit its mode drawn as NORMAL, and the finished group is blended once. A
		shape never needs this, because its graphics are already rendered to a single image before they
		are drawn.
	**/
	@:noCompletion private function __needsWholeObjectGroup(displayObject:DisplayObject, blendMode:BlendMode):Bool
	{
		var operatorMode = switch (blendMode)
		{
			case ADD, MULTIPLY, SCREEN, DIFFERENCE, LIGHTEN, DARKEN, HARDLIGHT, OVERLAY: true;
			default: false;
		}
		if (!operatorMode) return false;
		var children = displayObject.__children;
		if (children == null || children.length == 0) return false;
		var graphics = displayObject.__graphics;
		return children.length > 1 || (graphics != null && graphics.__commands.length > 0);
	}

	/**
		Renders `object` into a group bitmap (see `__renderIntoGroup`) and draws it onto the target as
		one image with the object's alpha: with OVER for a LAYER, or with the operator of `blendMode`
		for a container blended as a whole (see `__needsWholeObjectGroup`).
	**/
	@:noCompletion private function __renderGroup(object:IBitmapDrawable, blendMode:BlendMode = LAYER):Void
	{
		var displayObject:DisplayObject = cast object;
		var bounds = Rectangle.__pool.get();
		var visible = __getGroupBounds(displayObject, bounds);
		var x0 = Std.int(bounds.x),
			y0 = Std.int(bounds.y),
			width = Std.int(bounds.width),
			height = Std.int(bounds.height);
		Rectangle.__pool.release(bounds);
		if (!visible) return;

		var group = __renderIntoGroup(object, x0, y0, width, height, blendMode);

		cairo.save();
		cairo.identityMatrix();
		cairo.rectangle(x0, y0, width, height);
		cairo.clip();
		cairo.setSourceSurface(group.getSurface(), x0, y0);
		__setBlendModeCairo(cairo, blendMode);
		var alpha = __getAlpha(displayObject.__worldAlpha);
		if (alpha >= 1) cairo.paint();
		else
			cairo.paintWithAlpha(alpha);
		cairo.restore();
		__blendMode = null; // the operator is set again by the next __setBlendMode
	}

	/**
		The rectangle a group needs on the target: the object's bounds including filters, rounded out
		to whole pixels and clamped to the target. Returns false if nothing of it is left.
	**/
	@:noCompletion private function __getGroupBounds(displayObject:DisplayObject, bounds:Rectangle):Bool
	{
		displayObject.__getFilterBounds(bounds, displayObject.__renderTransform);
		if (__worldTransform != null) bounds.__transform(bounds, __worldTransform);
		var target:CairoImageSurface = __targetBitmap != null ? __targetBitmap.getSurface() : cast cairo.target;
		var x0 = Math.max(0, Math.floor(bounds.x)),
			y0 = Math.max(0, Math.floor(bounds.y));
		var x1 = Math.min(target.width, Math.ceil(bounds.right)),
			y1 = Math.min(target.height, Math.ceil(bounds.bottom));
		bounds.setTo(x0, y0, x1 - x0, y1 - y0);
		return bounds.width > 0 && bounds.height > 0;
	}

	/**
		`bitmap` if it is at least `width` x `height`, otherwise a new transparent bitmap at least that
		large in both dimensions, `bitmap` disposed.
	**/
	@:noCompletion private static function __scratchBitmap(bitmap:BitmapData, width:Int, height:Int):BitmapData
	{
		if (bitmap != null && bitmap.width >= width && bitmap.height >= height) return bitmap;
		var w = bitmap != null && bitmap.width > width ? bitmap.width : width;
		var h = bitmap != null && bitmap.height > height ? bitmap.height : height;
		if (bitmap != null) bitmap.dispose();
		return new BitmapData(w, h, true, 0);
	}

	/**
		A surface over `bitmap`'s bytes in another `format`, `widthScale` of its pixels per BGRA pixel
		(see `__compositeFormulaOnViews`).
	**/
	@:noCompletion private static function __view(bitmap:BitmapData, format:CairoFormat, widthScale:Int = 1):CairoImageSurface
	{
		return CairoImageSurface.create(bitmap.image.data.buffer, format, bitmap.width * widthScale, bitmap.height, bitmap.image.buffer.stride);
	}

	/**
		Renders `object` into the group bitmap of the current layer depth, whose (0, 0) is the target's
		(x0, y0), and returns it.

		The group is a buffer of its own: children keep their own modes (those that only inherit
		`blendMode` draw as NORMAL), the object's alpha is divided out to be applied once to the result,
		and touches are tracked (see `__touch`). A mode given to `BitmapData.draw` applies to the root
		only.

		The bitmap is cleared through a view of its bytes and its surface is made afterwards: Cairo
		treats a surface it has cleared as empty, whatever is later written into the bytes.
	**/
	@:noCompletion private function __renderIntoGroup(object:IBitmapDrawable, x0:Int, y0:Int, width:Int, height:Int, blendMode:BlendMode):BitmapData
	{
		var displayObject:DisplayObject = cast object;
		var previousGroupBlendMode = __groupBlendMode,
			previousOverride = __overrideBlendMode;
		if (blendMode != LAYER) __groupBlendMode = blendMode;
		__overrideBlendMode = null;
		var group = __groupBitmaps[__layerDepth] = __scratchBitmap(__groupBitmaps[__layerDepth], width, height);
		var clear = new Cairo(__view(group, CairoFormat.ARGB32));
		clear.setOperator(CairoOperator.CLEAR);
		clear.rectangle(0, 0, width, height);
		clear.fill();
		group.__surface = null;

		var parentContext = cairo,
			parentTransform = __worldTransform,
			parentTarget = __targetBitmap;
		var transform = Matrix.__pool.get();
		if (parentTransform != null) transform.copyFrom(parentTransform);
		transform.translate(-x0, -y0);
		cairo = new Cairo(group.getSurface());
		__worldTransform = transform;
		__targetBitmap = group;
		var parentAlphaPlane = __alphaPlane,
			parentAlphaPlaneRect = __alphaPlaneRect;
		__alphaPlane = null;
		__layerDepth++;
		var parentLevel = __bufferLevel, parentDrawn = __bufferHasContent;
		__openBuffer();
		__blendMode = null;
		// the group tracks what its children touch, from the moment a child needs it (see __ensureTouched)
		var parentTouchedRoot = __touchedGroup,
			parentTouched = __touched,
			parentTouchedBitmap = __touchedBitmap;
		var parentTouchedActive = __touchedBuilt;
		var parentTouchedWidth = __touchedWidth,
			parentTouchedHeight = __touchedHeight;
		__touchedGroup = displayObject;
		__touched = null;
		__touchedBitmap = null;
		__touchedBuilt = false;
		__touchedWidth = width;
		__touchedHeight = height;
		// the object's alpha applies once, to the composite: divided out of the children here
		var cacheWorldAlpha = __worldAlpha;
		__worldAlpha = 1 / displayObject.__worldAlpha;
		__renderDrawableDirect(object);
		if (__alphaPlane != null) __mergeAlphaPlane();
		__worldAlpha = cacheWorldAlpha;
		__touchedGroup = parentTouchedRoot;
		__touched = parentTouched;
		__touchedBitmap = parentTouchedBitmap;
		__touchedBuilt = parentTouchedActive;
		__touchedWidth = parentTouchedWidth;
		__touchedHeight = parentTouchedHeight;
		__closeBuffer(parentLevel, parentDrawn);
		__layerDepth--;
		__alphaPlane = parentAlphaPlane;
		__alphaPlaneRect = parentAlphaPlaneRect;
		__targetBitmap = parentTarget;
		__worldTransform = parentTransform;
		Matrix.__pool.release(transform);
		cairo = parentContext;
		__groupBlendMode = previousGroupBlendMode;
		__overrideBlendMode = previousOverride;
		return group;
	}

	/**
		Composites `object` with SUBTRACT, INVERT, ERASE or ALPHA, which have no single Cairo operator.
		The object is read from its own surface when it is one piece at full alpha
		(see `__leafPattern`), otherwise from a group bitmap (see `__renderIntoGroup`). On a transparent
		target SUBTRACT and INVERT go through `__compositeFormulaOnViews`; everything else uses plain
		operators.
	**/
	@:noCompletion private function __renderFormulaGroup(object:IBitmapDrawable, blendMode:BlendMode):Void
	{
		var displayObject:DisplayObject = cast object;
		if (displayObject.__worldAlpha <= 0) return;

		// the clip and the groups work at the object's size, and DEST_IN (ALPHA), which is unbounded,
		// cannot reach outside it
		var bounds = Rectangle.__pool.get();
		var visible = __getGroupBounds(displayObject, bounds);
		var x0 = Std.int(bounds.x),
			y0 = Std.int(bounds.y),
			width = Std.int(bounds.width),
			height = Std.int(bounds.height);
		Rectangle.__pool.release(bounds);
		if (!visible) return;

		// the mode this group is composited with, for the shapes rendered inside it (__isCompositedWithAlpha)
		var previousGroupBlendMode = __groupBlendMode;
		__groupBlendMode = blendMode;

		cairo.save();
		cairo.identityMatrix();
		cairo.rectangle(x0, y0, width, height);
		cairo.clip();

		// a one-piece object at full alpha is composited straight from its own surface, anything
		// else from a bitmap of ours it is rendered into (see __renderIntoGroup)
		var alpha = __getAlpha(displayObject.__worldAlpha);
		var objectPattern = alpha >= 1 ? __leafPattern(displayObject) : null;

		if (objectPattern == null)
		{
			var group = __renderIntoGroup(object, x0, y0, width, height, blendMode);
			if (alpha < 1)
			{
				// the object's alpha applies once, to the whole object
				var scale = new Cairo(group.getSurface());
				scale.setSourceRGBA(0, 0, 0, alpha);
				scale.setOperator(CairoOperator.DEST_IN);
				scale.rectangle(0, 0, width, height);
				scale.fill();
			}
			objectPattern = CairoPattern.createForSurface(group.getSurface());
			// a pattern matrix maps device to pattern space: the bitmap's (0, 0) is the target's (x0, y0)
			__matrix3.setTo(1, 0, 0, 1, -x0, -y0);
			objectPattern.matrix = __matrix3;
		}

		// SUBTRACT and INVERT need views of the target's bytes where it is transparent; everything
		// else works with operators
		if ((blendMode == SUBTRACT || blendMode == INVERT) && !__backdropIsOpaque())
		{
			__ensureTouched(displayObject);
			__compositeFormulaOnViews(objectPattern, blendMode, x0, y0, width, height);
		}
		else
		{
			// a cutter following the touched model shows itself over what is not covered
			var uncovered:CairoPattern = null;
			if ((blendMode == ALPHA || blendMode == ERASE) && __cutterShowsAsIs())
			{
				__ensureTouched(displayObject);
				if (__touchedBuilt) uncovered = __uncoveredPattern(objectPattern);
			}

			switch (blendMode)
			{
				case ALPHA, ERASE:
					__compositeAlphaErase(objectPattern, blendMode, displayObject);
				case INVERT:
					__compositeInvert(objectPattern);
				case SUBTRACT:
					__compositeSubtract(__premultipliedPattern(objectPattern));
				default:
			}

			if (uncovered != null)
			{
				cairo.source = uncovered;
				cairo.setOperator(CairoOperator.ADD);
				cairo.paint();
			}
		}

		cairo.restore();
		__blendMode = null;
		__groupBlendMode = previousGroupBlendMode;
	}

	/**
		The object over the pixels the touched buffer does not cover, (1 - c) S: what a SUBTRACT or
		INVERT object, or a cutter following the touched model, shows as it is.
	**/
	@:noCompletion private function __uncoveredPattern(objectPattern:CairoPattern):CairoPattern
	{
		cairo.pushGroupWithContent(CairoContent.COLOR_ALPHA);
		cairo.source = objectPattern;
		cairo.setOperator(CairoOperator.OVER);
		cairo.paint();
		cairo.setSourceSurface(__touchedBitmap.getSurface(), 0, 0);
		cairo.setOperator(CairoOperator.DEST_OUT);
		cairo.paint();
		return cairo.popGroup();
	}

	/**
		Returns a pattern of a single-piece object's own pixels, a Bitmap's bitmapData or a Shape's
		rendered graphics, positioned exactly where the object is drawn. The composite functions can
		read the object from it without rendering it into a group first. Returns null if the object is
		not a single piece (see `__isBlendLeaf`) or has nothing to draw.
	**/
	@:noCompletion private function __leafPattern(displayObject:DisplayObject):CairoPattern
	{
		if (!__isBlendLeaf(displayObject)) return null;

		var surface:CairoSurface = null;
		var transform = Matrix.__pool.get();
		var pattern:CairoPattern = null;
		var graphics = displayObject.__graphics;

		if (graphics == null)
		{
			var bitmap:Bitmap = cast displayObject;
			var bitmapData = bitmap.__bitmapData;
			if (bitmapData != null && bitmapData.__isValid)
			{
				if (bitmapData.image != null) bitmap.__imageVersion = bitmapData.image.version;
				surface = bitmapData.getSurface();
				transform.copyFrom(bitmap.__renderTransform);
				if (surface != null)
				{
					pattern = CairoPattern.createForSurface(surface);
					pattern.filter = (__allowSmoothing && bitmap.smoothing) ? CairoFilter.GOOD : CairoFilter.NEAREST;
				}
			}
		}
		else
		{
			#if lime_cairo
			CairoGraphics.render(graphics, this, __isCompositedWithAlpha(displayObject));
			if (graphics.__cairo != null && graphics.__visible && graphics.__width >= 1 && graphics.__height >= 1)
			{
				surface = graphics.__cairo.target;
				transform.scale(1 / graphics.__bitmapScaleX, 1 / graphics.__bitmapScaleY);
				transform.concat(graphics.__worldTransform);
				pattern = CairoPattern.createForSurface(surface);
			}
			#end
		}

		if (pattern != null)
		{
			// as applyMatrix places the surface, inverted: a pattern matrix maps device to pattern space
			if (__worldTransform != null) transform.concat(__worldTransform);
			if (__roundPixels)
			{
				transform.tx = Math.round(transform.tx);
				transform.ty = Math.round(transform.ty);
			}
			transform.invert();
			__matrix3.a = transform.a;
			__matrix3.b = transform.b;
			__matrix3.c = transform.c;
			__matrix3.d = transform.d;
			__matrix3.tx = transform.tx;
			__matrix3.ty = transform.ty;
			pattern.matrix = __matrix3;
		}

		Matrix.__pool.release(transform);
		__renderEvent(displayObject);
		return pattern;
	}

	@:noCompletion private function __compositeAlphaErase(objectPattern:CairoPattern, blendMode:BlendMode, displayObject:DisplayObject):Void
	{
		if (blendMode == ALPHA && __alphaNeedsMask(displayObject))
		{
			// Flash's ALPHA masks with what the object's leaves cover: a Bitmap its footprint,
			// transparent pixels included, a shape only its fills, and the part of the object's
			// box that no leaf covers keeps the backdrop. At an anti-aliased edge coverage and
			// fill alpha stay apart too. DEST_IN cuts wherever the source is transparent, so the
			// mask is 1 - coverage + alpha, built in a group over the clip with operators alone:
			// opaque, the coverage taken out (DEST_OUT), the object added (ADD, which clamps at 1)
			cairo.pushGroupWithContent(CairoContent.COLOR_ALPHA);
			cairo.setSourceRGB(0, 0, 0);
			cairo.setOperator(CairoOperator.SOURCE);
			cairo.paint();
			cairo.setOperator(CairoOperator.DEST_OUT);
			__drawCoverage(cairo, displayObject);
			cairo.identityMatrix();
			cairo.source = objectPattern;
			cairo.setOperator(CairoOperator.ADD);
			cairo.paint();
			cairo.popGroupToSource();
		}
		else
		{
			cairo.source = objectPattern;
		}

		cairo.setOperator(blendMode == ERASE ? CairoOperator.DEST_OUT : CairoOperator.DEST_IN);
		cairo.paint();

		if (__backdropIsOpaque())
		{
			// Flash keeps an opaque bitmap opaque: black behind the cut out pixels
			cairo.setSourceRGB(0, 0, 0);
			cairo.setOperator(CairoOperator.DEST_OVER);
			cairo.paint();
		}
	}

	/**
		Paints the area covered by `displayObject` and its descendants into `coverage`, a context in the
		target's coordinates, with its current operator: graphics through `__drawGraphicsCoverage`,
		other leaves as their bounding box.
	**/
	@:noCompletion private function __drawCoverage(coverage:Cairo, displayObject:DisplayObject):Void
	{
		if (!displayObject.__renderable) return;
		var graphics = displayObject.__graphics;

		if (graphics != null) __drawGraphicsCoverage(coverage, displayObject);

		if (displayObject.__children != null)
		{
			for (child in displayObject.__children)
				__drawCoverage(coverage, child);
		}
		else if (graphics == null)
		{
			var bounds = Rectangle.__pool.get();
			var matrix = Matrix.__pool.get();
			displayObject.__getBounds(bounds, Matrix.__identity);
			matrix.copyFrom(displayObject.__renderTransform);
			__applyCoverageMatrix(coverage, matrix);
			coverage.setSourceRGB(0, 0, 0);
			coverage.rectangle(bounds.x, bounds.y, bounds.width, bounds.height);
			coverage.fill();
			Matrix.__pool.release(matrix);
			Rectangle.__pool.release(bounds);
		}
	}

	/**
		Paints the area covered by the graphics of `displayObject` into `coverage`
		(see `__drawCoverage`): a shape's coverage render, made if missing, or for a text field the
		alpha of its bitmap, which it draws in opaque colors. Without either, the whole bitmap.
	**/
	@:noCompletion private function __drawGraphicsCoverage(coverage:Cairo, displayObject:DisplayObject):Void
	{
		var graphics = displayObject.__graphics;
		CairoGraphics.render(graphics, this, true);
		if (graphics.__bitmap == null) return;

		var matrix = Matrix.__pool.get();
		matrix.scale(1 / graphics.__bitmapScaleX, 1 / graphics.__bitmapScaleY);
		matrix.concat(graphics.__worldTransform);
		__applyCoverageMatrix(coverage, matrix);
		if (graphics.__coverage != null)
		{
			coverage.setSourceSurface(graphics.__coverage.getSurface(), 0, 0);
			coverage.rectangle(0, 0, graphics.__coverage.width, graphics.__coverage.height);
		}
		else if (graphics.__managed)
		{
			// a text field draws straight into its bitmap, in colors that are always opaque, so
			// the bitmap's own alpha is its coverage
			coverage.setSourceSurface(graphics.__bitmap.getSurface(), 0, 0);
			coverage.rectangle(0, 0, graphics.__bitmap.width, graphics.__bitmap.height);
		}
		else
		{
			coverage.setSourceRGB(0, 0, 0);
			coverage.rectangle(0, 0, graphics.__bitmap.width, graphics.__bitmap.height);
		}
		coverage.fill();
		Matrix.__pool.release(matrix);
	}

	/**
		Sets `coverage` to draw where the object is drawn: `matrix` with the world transform and pixel
		rounding applied.
	**/
	@:noCompletion private function __applyCoverageMatrix(coverage:Cairo, matrix:Matrix):Void
	{
		if (__worldTransform != null) matrix.concat(__worldTransform);
		if (__roundPixels)
		{
			matrix.tx = Math.round(matrix.tx);
			matrix.ty = Math.round(matrix.ty);
		}
		coverage.matrix = matrix.__toMatrix3();
	}

	/**
		Builds the group's touched buffer on first use (see `__touch`): the coverage of everything drawn
		into the group before `displayObject`. Objects drawn afterwards add themselves.
	**/
	@:noCompletion private function __ensureTouched(displayObject:DisplayObject):Void
	{
		if (__touchedGroup == null || __touchedBuilt) return;

		__touchedBitmap = __touchedBitmaps[__layerDepth] = __scratchBitmap(__touchedBitmaps[__layerDepth], __touchedWidth, __touchedHeight);
		__touched = new Cairo(__touchedBitmap.getSurface());
		__touched.setSourceRGBA(0, 0, 0, 0);
		__touched.setOperator(CairoOperator.SOURCE);
		__touched.rectangle(0, 0, __touchedWidth, __touchedHeight);
		__touched.fill();
		__touched.setOperator(CairoOperator.OVER);
		__touchedBuilt = true;
		__walkTouched(__touchedGroup, displayObject);
	}

	@:noCompletion private override function __drawTouched(displayObject:DisplayObject, graphicsOnly:Bool):Void
	{
		if (graphicsOnly) __drawGraphicsCoverage(__touched, displayObject);
		else
			__drawCoverage(__touched, displayObject);
	}

	/**
		Composites `objectPattern` onto a transparent target with SUBTRACT or INVERT, in place, over
		(x0, y0, width, height). With c the touched coverage (1 without a buffer) and D, S
		premultiplied:

		  SUBTRACT  color max(0, D - cS) + (1 - c) S      alpha min(1, s + Da)
		  INVERT    color D (1 - 2s) + cs + (1 - c) S     alpha s + Da (1 - s)

		No ARGB operator writes such a color and alpha at once, so they are written apart. The color
		goes on an RGB24 view of the bytes, which reads premultiplied color as opaque: SUBTRACT is a
		LIGHTEN then a DIFFERENCE with cS, plus (1 - c) S; INVERT is one DIFFERENCE with white where
		covered and the object where not, exact because the backdrop is never more opaque than its
		coverage. The alpha goes into an A8 plane that is written back once per run of such objects
		(see `__mergeAlphaPlane`).

		On the window, which is not a bitmap of ours, the rectangle is copied out, composited and
		painted back.
	**/
	@:noCompletion private function __compositeFormulaOnViews(objectPattern:CairoPattern, blendMode:BlendMode, x0:Int, y0:Int, width:Int, height:Int):Void
	{
		#if !js
		var target = __targetBitmap;
		var tx = 0, ty = 0;
		if (target == null)
		{
			target = __windowCopy = __scratchBitmap(__windowCopy, width, height);
			target.__surface = null;
			tx = x0;
			ty = y0;
			// the rectangle of the target, at the copy's origin, read through a group pattern: a
			// Cairo group target cannot be read by another context
			var destination = cairo.groupTarget;
			cairo.pushGroupWithContent(CairoContent.COLOR_ALPHA);
			cairo.setSourceSurface(destination, 0, 0);
			cairo.setOperator(CairoOperator.SOURCE);
			cairo.paint();
			var copy = new Cairo(target.getSurface());
			copy.translate(-tx, -ty);
			copy.source = cairo.popGroup();
			copy.setOperator(CairoOperator.SOURCE);
			copy.paint();
		}

		// the coverage as a pattern, and the object over what it does not cover, (1 - c) S
		var touched:CairoPattern = null;
		var uncovered:CairoPattern = null;
		if (__touchedBuilt)
		{
			cairo.setSourceSurface(__touchedBitmap.getSurface(), 0, 0);
			touched = cairo.source;
			uncovered = __uncoveredPattern(objectPattern);
		}

		// the alpha on its own: the object over the backdrop, in the run's plane, or for a copied
		// target in a group written back below
		var alpha:CairoPattern = null;
		if (target == __windowCopy)
		{
			cairo.pushGroupWithContent(CairoContent.ALPHA);
			cairo.setSourceSurface(__view(target, CairoFormat.ARGB32), tx, ty);
			cairo.setOperator(CairoOperator.SOURCE);
			cairo.paint();
			cairo.source = objectPattern;
			cairo.setOperator(blendMode == SUBTRACT ? CairoOperator.ADD : CairoOperator.OVER);
			cairo.paint();
			alpha = cairo.popGroup();
		}
		else
		{
			if (__alphaPlane == null)
			{
				var plane = __alphaPlanes[__layerDepth];
				if (plane == null || plane.width < target.width || plane.height < target.height)
				{
					plane = new CairoImageSurface(CairoFormat.A8, target.width, target.height);
					__alphaPlanes[__layerDepth] = plane;
				}
				__alphaPlane = new Cairo(plane);
				__alphaPlane.setSourceSurface(__view(target, CairoFormat.ARGB32), 0, 0);
				__alphaPlane.setOperator(CairoOperator.SOURCE);
				__alphaPlane.paint();
				__alphaPlaneRect = Rectangle.__pool.get();
				__alphaPlaneRect.setTo(x0, y0, width, height);
			}
			else
			{
				__alphaPlaneRect.__expand(x0, y0, width, height);
			}
			__alphaPlane.source = objectPattern;
			__alphaPlane.setOperator(blendMode == SUBTRACT ? CairoOperator.ADD : CairoOperator.OVER);
			__alphaPlane.paint();
		}

		// the color, on the RGB24 view
		var rgb = new Cairo(__view(target, CairoFormat.RGB24));
		rgb.translate(-tx, -ty);
		rgb.rectangle(x0, y0, width, height);
		rgb.clip();
		if (blendMode == INVERT)
		{
			// D (1 - 2s) + cs + (1 - c) S: one DIFFERENCE with white at the object's alpha, which
			// gives D (1 - 2s) + s, its color kept by the coverage and the object added over what
			// is not covered, which keeps the alpha at s
			if (uncovered == null)
			{
				rgb.setSourceRGB(1, 1, 1);
				rgb.setOperator(CairoOperator.DIFFERENCE);
				rgb.mask(objectPattern);
			}
			else
			{
				cairo.pushGroupWithContent(CairoContent.COLOR_ALPHA);
				cairo.setSourceRGB(1, 1, 1);
				cairo.setOperator(CairoOperator.OVER);
				cairo.mask(objectPattern);
				cairo.source = touched;
				cairo.setOperator(CairoOperator.DEST_IN);
				cairo.paint();
				cairo.source = uncovered;
				cairo.setOperator(CairoOperator.ADD);
				cairo.paint();
				rgb.source = cairo.popGroup();
				rgb.setOperator(CairoOperator.DIFFERENCE);
				rgb.paint();
			}
		}
		else
		{
			// max(0, D - cS) + (1 - c) S: a LIGHTEN then a DIFFERENCE with cS as opaque color, the
			// object painted through the coverage into a group of COLOR content, plus the object
			// as it is over what is not covered
			cairo.pushGroupWithContent(CairoContent.COLOR);
			cairo.source = objectPattern;
			cairo.setOperator(CairoOperator.OVER);
			if (touched != null) cairo.mask(touched);
			else
				cairo.paint();
			rgb.source = cairo.popGroup();
			rgb.setOperator(CairoOperator.LIGHTEN);
			rgb.paint();
			rgb.setOperator(CairoOperator.DIFFERENCE);
			rgb.paint();
			if (uncovered != null)
			{
				rgb.source = uncovered;
				rgb.setOperator(CairoOperator.ADD);
				rgb.paint();
			}
		}

		if (target == __windowCopy)
		{
			__writeAlphaBytes(target, alpha, x0 - tx, y0 - ty, width, height);
			target.__surface = null;
			cairo.setSourceSurface(target.getSurface(), tx, ty);
			cairo.setOperator(CairoOperator.SOURCE);
			cairo.rectangle(x0, y0, width, height);
			cairo.fill();
		}
		#end
	}

	/**
		Writes `alpha` into the alpha bytes of `bitmap` over the rectangle, leaving the color alone:
		through an A8 view four times as wide, with a repeating mask that passes every fourth byte.
	**/
	@:noCompletion private function __writeAlphaBytes(bitmap:BitmapData, alpha:CairoPattern, x0:Int, y0:Int, width:Int, height:Int):Void
	{
		#if !js
		if (__alphaBytesMask == null)
		{
			// one opaque pixel in four, at the alpha byte of a BGRA pixel, repeated
			var maskSurface = new CairoImageSurface(CairoFormat.A8, 4, 1);
			var maskContext = new Cairo(maskSurface);
			maskContext.setSourceRGBA(0, 0, 0, 1);
			maskContext.rectangle(3, 0, 1, 1);
			maskContext.fill();
			__alphaBytesMask = CairoPattern.createForSurface(maskSurface);
			__alphaBytesMask.extend = CairoExtend.REPEAT;
			__alphaBytesMask.filter = CairoFilter.NEAREST;
		}
		var alphaBytes = new Cairo(__view(bitmap, CairoFormat.A8, 4));
		alphaBytes.rectangle(x0 * 4, y0, width * 4, height);
		alphaBytes.clip();
		alpha.filter = CairoFilter.NEAREST;
		__matrix3.setTo(0.25, 0, 0, 1, 0, 0);
		alpha.matrix = __matrix3;
		alphaBytes.source = alpha;
		alphaBytes.setOperator(CairoOperator.SOURCE);
		alphaBytes.mask(__alphaBytesMask);
		#end
	}

	/**
		Ends a SUBTRACT/INVERT run by writing the alpha plane into the target's alpha bytes.
	**/
	@:noCompletion private function __mergeAlphaPlane():Void
	{
		var rect = __alphaPlaneRect;
		__writeAlphaBytes(__targetBitmap, CairoPattern.createForSurface(__alphaPlane.target), Std.int(rect.x), Std.int(rect.y), Std.int(rect.width),
			Std.int(rect.height));
		Rectangle.__pool.release(rect);
		__alphaPlaneRect = null;
		__alphaPlane = null;
	}

	/**
		INVERT on an opaque target: a DIFFERENCE with white, masked by the object.
	**/
	@:noCompletion private function __compositeInvert(objectPattern:CairoPattern):Void
	{
		cairo.setSourceRGB(1, 1, 1);
		cairo.setOperator(CairoOperator.DIFFERENCE);
		cairo.mask(objectPattern);
	}

	/**
		Returns a copy of the object drawn over opaque black. In it every pixel holds the object's color
		already multiplied by its alpha, black where the object is transparent, with full alpha
		everywhere. `__compositeSubtract` needs its source in this form, because its two blend passes
		would otherwise apply the object's alpha twice at partly transparent pixels.
	**/
	@:noCompletion private function __premultipliedPattern(objectPattern:CairoPattern):CairoPattern
	{
		cairo.pushGroupWithContent(CairoContent.COLOR_ALPHA);
		cairo.setSourceRGB(0, 0, 0);
		cairo.setOperator(CairoOperator.SOURCE);
		cairo.paint();
		cairo.source = objectPattern;
		cairo.setOperator(CairoOperator.OVER);
		cairo.paint();
		return cairo.popGroup();
	}

	/**
		SUBTRACT on an opaque target: a LIGHTEN then a DIFFERENCE with `objectPattern`, which the caller
		has premultiplied over black (see `__premultipliedPattern`).
	**/
	@:noCompletion private function __compositeSubtract(objectPattern:CairoPattern):Void
	{
		cairo.source = objectPattern;
		cairo.setOperator(CairoOperator.LIGHTEN);
		cairo.paint();
		cairo.setOperator(CairoOperator.DIFFERENCE);
		cairo.paint();
	}

	/**
		Whether the current target is fully opaque, so that a composite can work on it directly without
		having to preserve its alpha.

		That is the case when drawing straight onto an opaque stage, and when drawing into an opaque
		BitmapData with `BitmapData.draw`. It is not the case inside any group this renderer has opened,
		on a transparent stage, or while rendering the cache bitmap of an object with filters or
		cacheAsBitmap, whose renderer is given the stage as well but actually draws into a transparent
		bitmap.
	**/
	@:noCompletion private inline function __backdropIsOpaque():Bool
	{
		return __layerDepth == 0 && (__stage != null ? (!__stage.__transparent && __stage.__renderer == this) : !__transparent);
	}
	#end

	@:noCompletion private function __renderDrawableDirect(object:IBitmapDrawable):Void
	{
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

	@:noCompletion private override function __setBlendMode(value:BlendMode, force:Bool = false):Void
	{
		if (__overrideBlendMode != null) value = __overrideBlendMode;
		if (value == __groupBlendMode) value = NORMAL;
		if (!force && __blendMode == value) return;

		__blendMode = value;
		__setBlendModeCairo(cairo, value);
	}

	@SuppressWarnings("checkstyle:Dynamic")
	@:noCompletion private function __setBlendModeCairo(cairo:#if lime Cairo #else Dynamic #end, value:BlendMode):Void
	{
		#if lime
		switch (value)
		{
			// ALPHA, ERASE, INVERT and SUBTRACT are rendered into a Cairo group and
			// composited with the destination in __renderFormulaGroup. Cairo has no operator
			// for the last two, and the first two need the object as one clipped piece.

			case ADD:
				cairo.setOperator(CairoOperator.ADD);

			case DARKEN:
				cairo.setOperator(CairoOperator.DARKEN);

			case DIFFERENCE:
				cairo.setOperator(CairoOperator.DIFFERENCE);

			case HARDLIGHT:
				cairo.setOperator(CairoOperator.HARD_LIGHT);

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

			default:
				cairo.setOperator(CairoOperator.OVER);
		}
		#end
	}
}
#else
typedef CairoRenderer = Dynamic;
#end
