package;

import openfl.geom.ColorTransform;
import utest.Assert;
import utest.Test;

class ColorTransformTest extends Test
{
	public function test_alphaMultiplier()
	{
		var base = new ColorTransform(0.1, 0.55, 0.4, 0.89123, -255, 5, 255, 123);

		Assert.equals(0.89123, base.alphaMultiplier);
	}

	public function test_alphaOffset()
	{
		var base = new ColorTransform(0.1, 0.55, 0.4, 0.89123, -255, 5, 255, 123);

		Assert.equals(123, base.alphaOffset);
	}

	public function test_blueMultiplier()
	{
		var base = new ColorTransform(0.1, 0.55, 0.4, 0.89123, -255, 5, 255, 123);

		Assert.equals(0.4, base.blueMultiplier);
	}

	public function test_blueOffset()
	{
		var base = new ColorTransform(0.1, 0.55, 0.4, 0.89123, -255, 5, 255, 123);

		Assert.equals(255, base.blueOffset);
	}

	public function test_color()
	{
		var base = new ColorTransform(0.1, 0.55, 0.4, 1.0, -255, 5, 255, 0);

		#if flash
		var color:UInt = 0xFF0105FF;
		#else
		var color:Int = 0xFF0105FF;
		#end

		Assert.equals(color, base.color);

		base.color = 0xABCDEF;

		Assert.equals(171, base.redOffset);
		Assert.equals(205, base.greenOffset);
		Assert.equals(239, base.blueOffset);
		Assert.equals(0, base.alphaOffset);

		Assert.equals(0.0, base.redMultiplier);
		Assert.equals(0.0, base.greenMultiplier);
		Assert.equals(0.0, base.blueMultiplier);
		Assert.equals(1.0, base.alphaMultiplier);
	}

	public function test_greenMultiplier()
	{
		var base = new ColorTransform(0.1, 0.55, 0.4, 0.89123, -255, 5, 255, 123);

		Assert.equals(0.55, base.greenMultiplier);
	}

	public function test_greenOffset()
	{
		var base = new ColorTransform(0.1, 0.55, 0.4, 0.89123, -255, 5, 255, 123);

		Assert.equals(5, base.greenOffset);
	}

	public function test_redMultiplier()
	{
		var base = new ColorTransform(0.1, 0.55, 0.4, 0.89123, -255, 5, 255, 123);

		Assert.equals(0.1, base.redMultiplier);
	}

	public function test_redOffset()
	{
		var base = new ColorTransform(0.1, 0.55, 0.4, 0.89123, -255, 5, 255, 123);

		Assert.equals(-255, base.redOffset);
	}

	public function test_new_()
	{
		var transformDefaults = new ColorTransform();

		Assert.equals(0.0, transformDefaults.redOffset);
		Assert.equals(0.0, transformDefaults.greenOffset);
		Assert.equals(0.0, transformDefaults.blueOffset);
		Assert.equals(0.0, transformDefaults.alphaOffset);

		Assert.equals(1.0, transformDefaults.redMultiplier);
		Assert.equals(1.0, transformDefaults.greenMultiplier);
		Assert.equals(1.0, transformDefaults.blueMultiplier);
		Assert.equals(1.0, transformDefaults.alphaMultiplier);

		var transformWithValues = new ColorTransform(0.1, 0.55, 0.4, 0.89123, -255, 5, 255, -123);

		Assert.equals(-255, transformWithValues.redOffset);
		Assert.equals(5, transformWithValues.greenOffset);
		Assert.equals(255, transformWithValues.blueOffset);
		Assert.equals(-123, transformWithValues.alphaOffset);

		Assert.equals(0.1, transformWithValues.redMultiplier);
		Assert.equals(0.55, transformWithValues.greenMultiplier);
		Assert.equals(0.4, transformWithValues.blueMultiplier);
		Assert.equals(0.891230, transformWithValues.alphaMultiplier);
	}

	public function test_concatDefaults()
	{
		var base = new ColorTransform();
		var second = new ColorTransform();

		base.concat(second);

		Assert.equals(0.0, base.redOffset);
		Assert.equals(0.0, base.greenOffset);
		Assert.equals(0.0, base.blueOffset);
		Assert.equals(0.0, base.alphaOffset);

		Assert.equals(1.0, base.redMultiplier);
		Assert.equals(1.0, base.greenMultiplier);
		Assert.equals(1.0, base.blueMultiplier);
		Assert.equals(1.0, base.alphaMultiplier);
	}

	public function test_concat1()
	{
		var base = new ColorTransform(0.1, 0.55, 0.4, 0.89123, -255, 5, 255, 123);
		var second = new ColorTransform(0.321, 0.33, 0.1, 0.123123, 200, -10, -100, 3);

		base.concat(second);


		Assert.equals(174.5, base.redOffset);
		Assert.equals(-7.25, base.greenOffset);
		Assert.equals(2, base.blueOffset);
		Assert.equals(112.6213, base.alphaOffset);

		Assert.equals(0.1 * 0.321, base.redMultiplier);
		Assert.equals(0.55 * 0.33, base.greenMultiplier);
		Assert.equals(0.4 * 0.1, base.blueMultiplier);
		Assert.equals(0.89123 * 0.123123, base.alphaMultiplier);
	}

	public function test_concat2()
	{
		// second should completely override base
		var base = new ColorTransform(0.5, 0.5, 0.5, 1, 0x80, 0, 0x80, 0);
		var second = new ColorTransform(0, 0, 0, 1, 0x62, 0x7D, 0xB0, 0);

		base.concat(second);


		Assert.equals(second.redOffset, base.redOffset);
		Assert.equals(second.greenOffset, base.greenOffset);
		Assert.equals(second.blueOffset, base.blueOffset);
		Assert.equals(second.alphaOffset, base.alphaOffset);

		Assert.equals(second.redMultiplier, base.redMultiplier);
		Assert.equals(second.greenMultiplier, base.greenMultiplier);
		Assert.equals(second.blueMultiplier, base.blueMultiplier);
		Assert.equals(second.alphaMultiplier, base.alphaMultiplier);
	}
}
