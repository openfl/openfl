package;

import openfl.display.Shape;
import utest.Assert;
import utest.Test;

class ShapeTest extends Test
{
	public function test_new_()
	{
		var shape = new Shape();

		var g1 = shape.graphics;
		var g2 = shape.graphics;

		Assert.notNull(g1);
		Assert.notNull(g2);

		Assert.equals(g1, g2);
	}

	public function test_graphics()
	{
		var shape = new Shape();

		var g1 = shape.graphics;
		var g2 = shape.graphics;

		Assert.notNull(g1);
		Assert.notNull(g2);

		Assert.equals(g1, g2);
	}
}
