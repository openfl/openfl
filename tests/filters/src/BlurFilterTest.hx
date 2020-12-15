package;

import openfl.filters.BlurFilter;
import utest.Assert;
import utest.Test;

class BlurFilterTest extends Test
{
	public function test_new_()
	{
		var blur = new BlurFilter();

		Assert.equals(4.0, blur.blurX);
		Assert.equals(4.0, blur.blurY);

		Assert.equals(1, blur.quality);

		blur = new BlurFilter(1.0, 2.0, 3);

		Assert.equals(1.0, blur.blurX);
		Assert.equals(2.0, blur.blurY);

		Assert.equals(3, blur.quality);
	}

	public function test_blurX()
	{
		var blur = new BlurFilter();
		blur.blurX = 123.234;

		Assert.equals(123.234, blur.blurX);
	}

	public function test_blurY()
	{
		var blur = new BlurFilter();
		blur.blurY = 31.31;

		Assert.equals(31.31, blur.blurY);
	}

	public function test_quality()
	{
		var blur = new BlurFilter();
		blur.quality = 2;

		Assert.equals(2, blur.quality);
	}
}
