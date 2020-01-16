package openfl.geom;

class ColorTransformTest
{
	@Test public function alphaMultiplier()
	{
		var base = new ColorTransform(0.1, 0.55, 0.4, 0.89123, -255, 5, 255, 123);

		Assert.areEqual(0.89123, base.alphaMultiplier);
	}

	@Test public function alphaOffset()
	{
		var base = new ColorTransform(0.1, 0.55, 0.4, 0.89123, -255, 5, 255, 123);

		Assert.areEqual(123, base.alphaOffset);
	}

	@Test public function blueMultiplier()
	{
		var base = new ColorTransform(0.1, 0.55, 0.4, 0.89123, -255, 5, 255, 123);

		Assert.areEqual(0.4, base.blueMultiplier);
	}

	@Test public function blueOffset()
	{
		var base = new ColorTransform(0.1, 0.55, 0.4, 0.89123, -255, 5, 255, 123);

		Assert.areEqual(255, base.blueOffset);
	}

	@Test public function color()
	{
		var base = new ColorTransform(0.1, 0.55, 0.4, 1.0, -255, 5, 255, 0);

		#if flash
		var color:UInt = 0xFF0105FF;
		#else
		var color:Int = 0xFF0105FF;
		#end

		Assert.areEqual(color, base.color);

		base.color = 0xABCDEF;

		Assert.areEqual(171, base.redOffset);
		Assert.areEqual(205, base.greenOffset);
		Assert.areEqual(239, base.blueOffset);
		Assert.areEqual(0, base.alphaOffset);

		Assert.areEqual(0.0, base.redMultiplier);
		Assert.areEqual(0.0, base.greenMultiplier);
		Assert.areEqual(0.0, base.blueMultiplier);
		Assert.areEqual(1.0, base.alphaMultiplier);
	}

	@Test public function greenMultiplier()
	{
		var base = new ColorTransform(0.1, 0.55, 0.4, 0.89123, -255, 5, 255, 123);

		Assert.areEqual(0.55, base.greenMultiplier);
	}

	@Test public function greenOffset()
	{
		var base = new ColorTransform(0.1, 0.55, 0.4, 0.89123, -255, 5, 255, 123);

		Assert.areEqual(5, base.greenOffset);
	}

	@Test public function redMultiplier()
	{
		var base = new ColorTransform(0.1, 0.55, 0.4, 0.89123, -255, 5, 255, 123);

		Assert.areEqual(0.1, base.redMultiplier);
	}

	@Test public function redOffset()
	{
		var base = new ColorTransform(0.1, 0.55, 0.4, 0.89123, -255, 5, 255, 123);

		Assert.areEqual(-255, base.redOffset);
	}

	@Test public function new_()
	{
		var transformDefaults = new ColorTransform();

		Assert.areEqual(0.0, transformDefaults.redOffset);
		Assert.areEqual(0.0, transformDefaults.greenOffset);
		Assert.areEqual(0.0, transformDefaults.blueOffset);
		Assert.areEqual(0.0, transformDefaults.alphaOffset);

		Assert.areEqual(1.0, transformDefaults.redMultiplier);
		Assert.areEqual(1.0, transformDefaults.greenMultiplier);
		Assert.areEqual(1.0, transformDefaults.blueMultiplier);
		Assert.areEqual(1.0, transformDefaults.alphaMultiplier);

		var transformWithValues = new ColorTransform(0.1, 0.55, 0.4, 0.89123, -255, 5, 255, -123);

		Assert.areEqual(-255, transformWithValues.redOffset);
		Assert.areEqual(5, transformWithValues.greenOffset);
		Assert.areEqual(255, transformWithValues.blueOffset);
		Assert.areEqual(-123, transformWithValues.alphaOffset);

		Assert.areEqual(0.1, transformWithValues.redMultiplier);
		Assert.areEqual(0.55, transformWithValues.greenMultiplier);
		Assert.areEqual(0.4, transformWithValues.blueMultiplier);
		Assert.areEqual(0.891230, transformWithValues.alphaMultiplier);
	}

	@Test public function concatDefaults()
	{
		var base = new ColorTransform();
		var second = new ColorTransform();

		base.concat(second);

		Assert.areEqual(0.0, base.redOffset);
		Assert.areEqual(0.0, base.greenOffset);
		Assert.areEqual(0.0, base.blueOffset);
		Assert.areEqual(0.0, base.alphaOffset);

		Assert.areEqual(1.0, base.redMultiplier);
		Assert.areEqual(1.0, base.greenMultiplier);
		Assert.areEqual(1.0, base.blueMultiplier);
		Assert.areEqual(1.0, base.alphaMultiplier);
	}

	@Test public function concat()
	{
		var base = new ColorTransform(0.1, 0.55, 0.4, 0.89123, -255, 5, 255, 123);
		var second = new ColorTransform(0.321, 0.33, 0.1, 0.123123, 200, -10, -100, 3);

		base.concat(second);

		Assert.areEqual(-235, base.redOffset);
		Assert.areEqual(-0.5, base.greenOffset);
		Assert.areEqual(215, base.blueOffset);
		Assert.areEqual(125.67369, base.alphaOffset);

		Assert.areEqual(0.1 * 0.321, base.redMultiplier);
		Assert.areEqual(0.55 * 0.33, base.greenMultiplier);
		Assert.areEqual(0.4 * 0.1, base.blueMultiplier);
		Assert.areEqual(0.89123 * 0.123123, base.alphaMultiplier);
	}
}
