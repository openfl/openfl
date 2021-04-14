package;

import openfl.display.BitmapData;
import openfl.display.GraphicsBitmapFill;
import openfl.geom.Matrix;
import utest.Assert;
import utest.Test;

class GraphicsBitmapFillTest extends Test
{
	public function test_bitmapData()
	{
		// TODO: Confirm functionality

		var bitmapFill = new GraphicsBitmapFill(new BitmapData(100, 100));
		var exists = bitmapFill.bitmapData;

		Assert.notNull(exists);
	}

	public function test_matrix()
	{
		// TODO: Confirm functionality

		var bitmapFill = new GraphicsBitmapFill(null, new Matrix());
		var exists = bitmapFill.matrix;

		Assert.notNull(exists);
	}

	public function test_repeat()
	{
		// TODO: Confirm functionality

		var bitmapFill = new GraphicsBitmapFill();
		var exists = bitmapFill.repeat;

		Assert.notNull(exists);
	}

	public function test_smooth()
	{
		// TODO: Confirm functionality

		var bitmapFill = new GraphicsBitmapFill();
		var exists = bitmapFill.smooth;

		Assert.notNull(exists);
	}

	public function test_new_()
	{
		// TODO: Confirm functionality

		var bitmapFill = new GraphicsBitmapFill();
		var exists = bitmapFill;

		Assert.notNull(exists);
	}
}
