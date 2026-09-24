package;

import openfl.display.BitmapData;
import openfl.display.Shape;
import openfl.text.TextField;
import openfl.text.TextFieldAutoSize;
import openfl.text.TextFormat;
import utest.Assert;
import utest.Test;

/**
 * Regression test for openfl/openfl#2866 and its follow-up.
 *
 * Two related invariants are checked:
 *
 *  1. **High-water-mark surface** — the cached Cairo surface holds
 *     `bitmap.width >= __width` and `bitmap.height >= __height` at all
 *     times. It grows on demand and is reused on shrink (no per-frame
 *     reallocation when bounds oscillate).
 *
 *  2. **Painted-region correctness** — the painted sub-region of the
 *     surface (the leading `__width × __height` pixels) contains the
 *     full drawn content. Context3DShape composites only this sub-region
 *     via `BitmapData.getVertexBuffer(..., paintedWidth, paintedHeight)`,
 *     so the right/bottom edges of the painted shape are never clipped
 *     by oversize transparent padding (the original bug).
 *
 * The test drives the software path through `BitmapData.draw`, which
 * routes to `CairoGraphics.render` on hxcpp/Cairo and exercises the
 * same surface lifecycle the Context3D path observes via the shared
 * `graphics.__bitmap`.
 */
@:access(openfl.display.Graphics)
@:access(openfl.text.TextField)
class CairoSurfaceSizeTest extends Test
{
	#if (cpp && lime_cairo)
	public function test_surfaceHoldsHighWaterAfterShrink()
	{
		var shape = new Shape();

		// First render: 200x100 fill -> surface allocated for the wider bounds.
		shape.graphics.beginFill(0xFF0000);
		shape.graphics.drawRect(0, 0, 200, 100);
		shape.graphics.endFill();

		var dst1 = new BitmapData(200, 100, true, 0);
		dst1.draw(shape);

		Assert.notNull(shape.graphics.__bitmap, "first render should produce a cached bitmap");
		Assert.isTrue(shape.graphics.__bitmap.width >= shape.graphics.__width,
			"first render: bitmap.width must cover painted width");
		Assert.isTrue(shape.graphics.__bitmap.height >= shape.graphics.__height,
			"first render: bitmap.height must cover painted height");

		var peakWidth = shape.graphics.__bitmap.width;
		var peakHeight = shape.graphics.__bitmap.height;

		// Shrink: same shape, narrower bounds. High-water surface holds peak —
		// `bitmap.width` stays at peakWidth, `bitmap.height` at peakHeight,
		// painted region shrinks to 100x100. Upstream's `>` + 1.25x check
		// produced the same hold but without the painted-region clamp at
		// composite, so the oversize padding visually clipped content.
		shape.graphics.clear();
		shape.graphics.beginFill(0xFF0000);
		shape.graphics.drawRect(0, 0, 100, 100);
		shape.graphics.endFill();

		var dst2 = new BitmapData(100, 100, true, 0);
		dst2.draw(shape);

		Assert.isTrue(shape.graphics.__bitmap.width >= shape.graphics.__width,
			"after shrink: bitmap.width must still cover painted width");
		Assert.isTrue(shape.graphics.__bitmap.height >= shape.graphics.__height,
			"after shrink: bitmap.height must still cover painted height");
		Assert.equals(peakWidth, shape.graphics.__bitmap.width,
			"after shrink: surface holds high-water (no reallocation)");
		Assert.equals(peakHeight, shape.graphics.__bitmap.height,
			"after shrink: surface holds high-water (no reallocation)");
	}

	public function test_surfaceGrowsOnGrow()
	{
		var shape = new Shape();

		shape.graphics.beginFill(0x00FF00);
		shape.graphics.drawRect(0, 0, 100, 100);
		shape.graphics.endFill();

		var dst1 = new BitmapData(100, 100, true, 0);
		dst1.draw(shape);

		Assert.isTrue(shape.graphics.__bitmap.width >= 100);
		Assert.isTrue(shape.graphics.__bitmap.height >= 100);

		// Grow: bounds expand to 200x100. Surface must grow to accommodate.
		shape.graphics.clear();
		shape.graphics.beginFill(0x00FF00);
		shape.graphics.drawRect(0, 0, 200, 100);
		shape.graphics.endFill();

		var dst2 = new BitmapData(200, 100, true, 0);
		dst2.draw(shape);

		Assert.isTrue(shape.graphics.__bitmap.width >= 200,
			"after grow: bitmap.width must cover new painted width");
		Assert.isTrue(shape.graphics.__bitmap.height >= 100,
			"after grow: bitmap.height must cover painted height");
	}

	public function test_textFieldSurfaceHoldsHighWaterAfterShrink()
	{
		// Same invariant for the parallel `CairoTextField` surface path. A
		// TextField sized 400x60 followed by a 100x60 redraw must keep the
		// wider surface around (high-water hold) while remaining at least
		// as wide as the new painted region. Driving through `BitmapData.draw`
		// routes to `CairoTextField.render` on hxcpp.
		var tf = new TextField();
		tf.autoSize = TextFieldAutoSize.NONE;
		tf.background = true;
		tf.backgroundColor = 0x00FF00;
		tf.width = 400;
		tf.height = 60;

		new BitmapData(400, 60, true, 0).draw(tf);

		Assert.notNull(tf.__graphics.__bitmap, "first render should produce a cached bitmap");
		Assert.isTrue(tf.__graphics.__bitmap.width >= tf.__graphics.__width);
		Assert.isTrue(tf.__graphics.__bitmap.height >= tf.__graphics.__height);

		var peakWidth = tf.__graphics.__bitmap.width;
		var peakHeight = tf.__graphics.__bitmap.height;

		// Shrink the visible area.
		tf.width = 100;
		new BitmapData(100, 60, true, 0).draw(tf);

		Assert.isTrue(tf.__graphics.__bitmap.width >= tf.__graphics.__width,
			"after shrink: TextField surface must cover painted width");
		Assert.isTrue(tf.__graphics.__bitmap.height >= tf.__graphics.__height,
			"after shrink: TextField surface must cover painted height");
		Assert.equals(peakWidth, tf.__graphics.__bitmap.width,
			"after shrink: TextField surface holds high-water (no reallocation)");
		Assert.equals(peakHeight, tf.__graphics.__bitmap.height,
			"after shrink: TextField surface holds high-water (no reallocation)");
	}

	public function test_textFieldSurfaceGrowsOnGrow()
	{
		var tf = new TextField();
		tf.autoSize = TextFieldAutoSize.NONE;
		tf.background = true;
		tf.backgroundColor = 0xFFFF00;
		tf.width = 100;
		tf.height = 60;

		new BitmapData(100, 60, true, 0).draw(tf);

		Assert.isTrue(tf.__graphics.__bitmap.width >= 100,
			"first render: surface must cover painted width");

		// Grow.
		tf.width = 300;
		new BitmapData(300, 60, true, 0).draw(tf);

		Assert.isTrue(tf.__graphics.__bitmap.width >= tf.__graphics.__width,
			"after grow: TextField surface must cover new painted width");
	}

	public function test_paintedRegionFullyOpaqueAtRightEdgeAfterShrink()
	{
		// End-to-end pixel-level check: after shrink, the rightmost column of
		// the painted region must contain the fill color. The Context3DShape
		// composite (via BitmapData.getVertexBuffer painted-region params)
		// must clamp to `__width × __height`, never sampling the transparent
		// padding that lives in the high-water surface past `__width`.
		var shape = new Shape();

		shape.graphics.beginFill(0xFF0000);
		shape.graphics.drawRect(0, 0, 200, 100);
		shape.graphics.endFill();
		new BitmapData(200, 100, true, 0).draw(shape);

		shape.graphics.clear();
		shape.graphics.beginFill(0xFF0000);
		shape.graphics.drawRect(0, 0, 100, 100);
		shape.graphics.endFill();

		var dst = new BitmapData(100, 100, true, 0);
		dst.draw(shape);

		// Sample inside the right edge (x=98) of the painted region.
		var px = dst.getPixel32(98, 50);
		Assert.equals(0xFFFF0000, px & 0xFFFFFFFF);
	}
	#else
	public function test_skippedOnNonCairoTarget()
	{
		// CairoGraphics surface allocation only runs on hxcpp/lime_cairo.
		Assert.isTrue(true);
	}
	#end
}
