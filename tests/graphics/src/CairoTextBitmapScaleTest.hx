package;

#if (!flash && lime_cairo)
import lime.graphics.cairo.Cairo;
import openfl.display.BitmapData;
import openfl.display.CairoRenderer;
import openfl.display.Sprite;
import openfl.display._internal.CairoGraphics;
import openfl.geom.Matrix;
import utest.Assert;
import utest.Test;

/**
	Regression test for the Retina text-doubling bug in CairoGraphics.render():
	when a TextField (via CairoTextField) writes a non-1 bitmapScale (= pixelRatio,
	e.g. 2 on Retina) and the graphics object then renders with `__softwareDirty=false`
	(a cache hit), the early-return must NOT have reset `__bitmapScaleX/Y` to 1
	beforehand — otherwise CairoShape composites the high-DPI text bitmap without
	the corresponding 1/pixelRatio downscale and the text visually doubles.

	The test uses an empty graphics (no draw commands → `__bounds == null`), so
	`Graphics.__update` returns early without touching `__dirty` / `__softwareDirty`.
	That isolates the bitmapScale-reset behaviour from the unrelated update path.
**/
class CairoTextBitmapScaleTest extends Test
{
	private function buildRenderer(pixelRatio:Float):CairoRenderer
	{
		var bmd = new BitmapData(10, 10, true, 0);
		var cairo = new Cairo(bmd.getSurface());
		var renderer = @:privateAccess new CairoRenderer(cairo);
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

		// Simulate CairoTextField setting a Retina pixelRatio on the cached bitmap.
		@:privateAccess g.__bitmapScaleX = 2.0;
		@:privateAccess g.__bitmapScaleY = 2.0;

		// Simulate a cache hit: nothing in the graphics changed, so render() must
		// early-return without touching bitmapScale.
		@:privateAccess g.__softwareDirty = false;
		@:privateAccess g.__managed = false;

		@:privateAccess CairoGraphics.render(g, buildRenderer(2.0));

		// With the fix: the early-return preserves the 2.0 we set.
		// Without the fix: render() resets bitmapScaleX/Y to 1 before the early-return.
		Assert.equals(2.0, @:privateAccess g.__bitmapScaleX);
		Assert.equals(2.0, @:privateAccess g.__bitmapScaleY);
	}

	public function test_managedGraphicsAlsoPreservesBitmapScale()
	{
		// Same scenario, but __managed=true (the other half of the early-return condition).
		var sprite = new Sprite();
		sprite.graphics;
		var g = @:privateAccess sprite.__graphics;

		@:privateAccess g.__bitmapScaleX = 1.5;
		@:privateAccess g.__bitmapScaleY = 1.5;
		@:privateAccess g.__softwareDirty = true; // would normally proceed
		@:privateAccess g.__managed = true; // but __managed forces early-return

		@:privateAccess CairoGraphics.render(g, buildRenderer(1.5));

		Assert.equals(1.5, @:privateAccess g.__bitmapScaleX);
		Assert.equals(1.5, @:privateAccess g.__bitmapScaleY);
	}
}
#else
import utest.Test;
class CairoTextBitmapScaleTest extends Test
{
	public function test_skippedOnNonCairo() {}
}
#end
