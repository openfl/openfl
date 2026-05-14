package;

#if (js && html5)
import openfl.display.CanvasRenderer;
import openfl.display.Sprite;
import openfl.display._internal.CanvasGraphics;
import openfl.display._internal.CanvasTextField;
import openfl.filters.GlowFilter;
import openfl.geom.ColorTransform;
import openfl.geom.Matrix;
import openfl.text.TextField;
import openfl.text.TextFieldAutoSize;
import openfl.text.TextFormat;
import utest.Assert;
import utest.Test;

/**
	Companion to CairoTextBitmapScaleTest, asserting the same structural
	property for the Canvas renderer.

	CanvasGraphics.render() resets `graphics.__bitmapScaleX/Y` to 1
	(or `__owner.scaleX/Y` for scale9Grid) BEFORE the
	`if (graphics.__softwareDirty)` work gate. On a cache hit
	(__softwareDirty=false) the function still clobbers the bitmapScale
	value that CanvasTextField wrote on the previous dirty render
	(== pixelRatio).

	The reset on cache hits is currently masked by a self-heal in
	CanvasTextField (`if (__bitmapScale != pixelRatio) __softwareDirty = true`,
	~CanvasTextField.hx:99-105), which forces a re-render every frame and
	restores the value. So stock html5 looks visually correct but pays an
	avoidable re-render cost; and a literal port of the Cairo fix (move the
	reset past the dirty gate) without auditing the filter pipeline can
	surface a separate half-size symptom on filtered TextFields (see
	openfl/openfl#2867 discussion).

	This test isolates the reset behaviour from the surrounding pipeline so
	the structural bug can be asserted directly: empty Graphics (no draw
	commands → __bounds == null → Graphics.__update early-returns without
	touching __dirty / __softwareDirty), pre-seeded bitmapScale, then a
	single CanvasGraphics.render() call.
**/
class CanvasGraphicsBitmapScaleTest extends Test
{
	private function buildRenderer(pixelRatio:Float):CanvasRenderer
	{
		var canvas:js.html.CanvasElement = cast js.Browser.document.createElement("canvas");
		canvas.width = 10;
		canvas.height = 10;
		var context:js.html.CanvasRenderingContext2D = cast canvas.getContext("2d");
		var renderer = @:privateAccess new CanvasRenderer(context);
		@:privateAccess renderer.__pixelRatio = pixelRatio;
		@:privateAccess renderer.__worldTransform = new Matrix();
		return renderer;
	}

	public function test_cacheHitPreservesNonOneBitmapScale()
	{
		var sprite = new Sprite();
		// Force-create the Graphics instance via the getter, but draw nothing
		// so __bounds stays null and Graphics.__update early-returns without
		// invalidating __softwareDirty.
		sprite.graphics;

		var g = @:privateAccess sprite.__graphics;

		// Simulate CanvasTextField setting a Retina pixelRatio on the cached bitmap.
		@:privateAccess g.__bitmapScaleX = 2.0;
		@:privateAccess g.__bitmapScaleY = 2.0;

		// Simulate a cache hit: nothing in the graphics changed, so render()
		// must NOT clobber bitmapScale.
		@:privateAccess g.__softwareDirty = false;

		@:privateAccess CanvasGraphics.render(g, buildRenderer(2.0));

		// Expected (after a structural fix mirroring PR #2867 for Canvas):
		//   bitmapScale stays at the 2.0 written by CanvasTextField.
		// Current stock behaviour:
		//   render() resets to 1 unconditionally before the softwareDirty gate
		//   and this assertion fails — documenting the same bug as Cairo.
		Assert.equals(2.0, @:privateAccess g.__bitmapScaleX);
		Assert.equals(2.0, @:privateAccess g.__bitmapScaleY);
	}

	/**
		Visual regression test: a filtered TextField rendered at pixelRatio=2
		must populate its `__cacheBitmap.__bitmapData` with glyphs at PIXEL
		resolution (i.e. fontSize × pixelRatio device pixels tall), not at
		LOGICAL resolution (fontSize device pixels tall, which is what a
		literal port of openfl/openfl#2867's Cairo fix produces).

		The mechanism: `CanvasShape.render()` composites via
		`drawImage(canvas, 0, 0, graphics.__width, graphics.__height)`, where
		the (W, H) args already account for the source canvas being at
		`pixelRatio` resolution. The renderer's `__worldTransform` is
		pre-scaled by `pixelRatio` for cache rendering (see
		DisplayObjectRenderer.hx:590). For the composite to land at 1:1
		source-pixel-to-cache-bitmap-pixel mapping, the `scale(1/bitmapScale)`
		applied by CanvasShape must be identity — i.e. `__bitmapScale` must be
		`1` at composite time. CanvasGraphics.render()'s pre-gate reset to 1
		is what enforces that invariant; moving the reset past the
		softwareDirty gate (the natural Cairo-style fix) leaves
		`__bitmapScale = pixelRatio` from CanvasTextField, causing
		`scale(1/2) * scale(pixelRatio) = scale(1)` instead of the required
		`scale(1) * scale(pixelRatio) = scale(2)`, which halves glyph height
		in the cache bitmap.
	**/
	public function test_filteredTextFieldCacheBitmapKeepsPixelResolutionAtDpr2()
	{
		var tf = new TextField();
		tf.defaultTextFormat = new TextFormat("_sans", 24, 0xffffff);
		tf.autoSize = TextFieldAutoSize.LEFT;
		tf.text = "T";
		tf.filters = [new GlowFilter(0xff5566, 1, 4, 4, 1)];

		// Initialise world transforms so __updateCacheBitmap can run.
		@:privateAccess tf.__update(false, true);

		// CanvasRenderer at DPR=2 backed by an off-DOM canvas.
		var canvas:js.html.CanvasElement = cast js.Browser.document.createElement("canvas");
		canvas.width = 400;
		canvas.height = 200;
		var context:js.html.CanvasRenderingContext2D = cast canvas.getContext("2d");
		var renderer = @:privateAccess new CanvasRenderer(context);
		@:privateAccess renderer.__pixelRatio = 2.0;
		@:privateAccess renderer.__worldTransform = new Matrix();
		@:privateAccess renderer.__worldAlpha = 1.0;
		@:privateAccess renderer.__worldColorTransform = new ColorTransform();

		// Drive the cache bitmap pipeline (filter forces cacheAsBitmap).
		@:privateAccess renderer.__updateCacheBitmap(tf, true);

		var cacheBitmap = @:privateAccess tf.__cacheBitmap;
		Assert.notNull(cacheBitmap, "cache bitmap should have been allocated");
		if (cacheBitmap == null) return;

		var bmd = cacheBitmap.bitmapData;
		Assert.notNull(bmd, "cache bitmap data should have been populated");
		if (bmd == null) return;

		// Measure vertical bounding box of non-transparent pixels (the glyph
		// plus its glow halo).
		var minY = bmd.height;
		var maxY = -1;
		for (y in 0...bmd.height)
		{
			var rowHasPixel = false;
			var x = 0;
			while (x < bmd.width)
			{
				if ((bmd.getPixel32(x, y) >>> 24) != 0)
				{
					rowHasPixel = true;
					break;
				}
				x++;
			}
			if (rowHasPixel)
			{
				if (y < minY) minY = y;
				if (y > maxY) maxY = y;
			}
		}
		var glyphHeight = maxY < 0 ? 0 : (maxY - minY + 1);

		// At fontSize=24, pixelRatio=2: glyph height in the cache bitmap
		// should be approximately 48 device pixels (logical 24px × DPR 2),
		// plus glow halo (~4-8px on each side). Stock CanvasGraphics: ~50-60px.
		// Literal-Cairo-port half-size regression: ~24-32px.
		Assert.isTrue(glyphHeight > 36,
			"cache bitmap glyph too small at DPR=2 — half-size regression? height=" + glyphHeight + "px");
	}
}
#else
import utest.Assert;
import utest.Test;

class CanvasGraphicsBitmapScaleTest extends Test
{
	public function test_skippedOnNonHtml5()
	{
		Assert.pass();
	}
}
#end
