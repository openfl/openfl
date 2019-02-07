package openfl.filters;

import massive.munit.Assert;

class BlurFilterTest
{
	@Test public function new_()
	{
		var blur = new BlurFilter();

		Assert.areEqual(4.0, blur.blurX);
		Assert.areEqual(4.0, blur.blurY);

		Assert.areEqual(1, blur.quality);

		blur = new BlurFilter(1.0, 2.0, 3);

		Assert.areEqual(1.0, blur.blurX);
		Assert.areEqual(2.0, blur.blurY);

		Assert.areEqual(3, blur.quality);
	}

	@Test public function blurX()
	{
		var blur = new BlurFilter();
		blur.blurX = 123.234;

		Assert.areEqual(123.234, blur.blurX);
	}

	@Test public function blurY()
	{
		var blur = new BlurFilter();
		blur.blurY = 31.31;

		Assert.areEqual(31.31, blur.blurY);
	}

	@Test public function quality()
	{
		var blur = new BlurFilter();
		blur.quality = 2;

		Assert.areEqual(2, blur.quality);
	}
}
