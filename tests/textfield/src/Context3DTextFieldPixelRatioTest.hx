package;

#if !flash
import openfl.display.OpenGLRenderer;
import openfl.display._internal.Context3DTextField;
import openfl.geom.Matrix;
import utest.Assert;
import utest.Test;

/**
	Regression test for `Context3DTextField.__computePixelRatio`: the helper
	that picks the resolution at which a TextField's bitmap is rasterized
	(via the software CairoRenderer / CanvasRenderer) before being composited
	by the GL renderer. The naive implementation reads only
	`renderer.__pixelRatio` (= `window.scale`), which ignores any scale
	applied higher up in the display tree or by a draw matrix. This test
	exercises the four meaningful inputs to the helper.

	The renderer instance is created with `Type.createEmptyInstance` so we
	don't have to stand up a real `Context3D` for a pure-math test.
**/
class Context3DTextFieldPixelRatioTest extends Test
{
	private function makeRenderer(pixelRatio:Float, worldTransform:Matrix):OpenGLRenderer
	{
		var renderer:OpenGLRenderer = Type.createEmptyInstance(OpenGLRenderer);
		@:privateAccess renderer.__pixelRatio = pixelRatio;
		@:privateAccess renderer.__worldTransform = worldTransform;
		return renderer;
	}

	public function test_returnsPixelRatioWhenTransformIsIdentity()
	{
		// Retina screen, identity transform → effective = window.scale.
		var renderer = makeRenderer(2.0, new Matrix());
		Assert.equals(2.0, @:privateAccess Context3DTextField.__computePixelRatio(renderer));
	}

	public function test_returnsTransformScaleWhenLargerThanPixelRatio()
	{
		// Windows non-HiDPI screen (window.scale=1), but a parent container or
		// draw matrix scales by 2. The bitmap should be rasterized at 2.0 so
		// it stays crisp after the 2x composite.
		var m = new Matrix();
		m.scale(2.0, 2.0);
		var renderer = makeRenderer(1.0, m);
		Assert.equals(2.0, @:privateAccess Context3DTextField.__computePixelRatio(renderer));
	}

	public function test_returnsPixelRatioWhenTransformIsDownscaling()
	{
		// Retina with a 0.5x downscale: a 0.5x bitmap on a Retina screen would
		// still look soft. Keep the device DPI as the floor.
		var m = new Matrix();
		m.scale(0.5, 0.5);
		var renderer = makeRenderer(2.0, m);
		Assert.equals(2.0, @:privateAccess Context3DTextField.__computePixelRatio(renderer));
	}

	public function test_picksLargerAxisFromAnisotropicTransform()
	{
		// scaleX = 3, scaleY = 1 → take 3 as the magnitude.
		var m = new Matrix();
		m.scale(3.0, 1.0);
		var renderer = makeRenderer(1.0, m);
		Assert.equals(3.0, @:privateAccess Context3DTextField.__computePixelRatio(renderer));
	}

	public function test_handlesRotationCorrectly()
	{
		// 45-degree rotation + 2x uniform scale. Scale magnitude per axis
		// is sqrt(a^2 + b^2) = sqrt((sqrt(2))^2 + (sqrt(2))^2) = 2.
		var m = new Matrix();
		m.scale(2.0, 2.0);
		m.rotate(Math.PI / 4);
		var renderer = makeRenderer(1.0, m);
		var actual:Float = @:privateAccess Context3DTextField.__computePixelRatio(renderer);
		Assert.isTrue(Math.abs(actual - 2.0) < 1e-9);
	}

	public function test_returnsPixelRatioWhenTransformIsNull()
	{
		// Defensive: the helper falls back to pixelRatio if worldTransform
		// is null (e.g. renderer setup mid-construction).
		var renderer = makeRenderer(2.0, null);
		Assert.equals(2.0, @:privateAccess Context3DTextField.__computePixelRatio(renderer));
	}
}
#else
import utest.Assert;
import utest.Test;
class Context3DTextFieldPixelRatioTest extends Test
{
	public function test_skippedOnFlash()
	{
		Assert.isTrue(true);
	}
}
#end
