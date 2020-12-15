package;

import openfl.filters.BlurFilter;
import utest.Assert;
import utest.Test;

class BitmapFilterTest extends Test
{
	public function test_new_()
	{
		// TODO: Confirm functionality

		var bitmapFilter = new BlurFilter();
		Assert.notNull(bitmapFilter);
	}

	public function test_clone()
	{
		// TODO: Confirm functionality

		var bitmapFilter = new BlurFilter();
		var exists = bitmapFilter.clone;

		Assert.notNull(exists);
	}
}
