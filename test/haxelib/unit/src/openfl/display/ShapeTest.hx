package openfl.display;

import massive.munit.Assert;
import openfl.display.Shape;

class ShapeTest
{
	@Test public function new_()
	{
		var shape = new Shape();

		var g1 = shape.graphics;
		var g2 = shape.graphics;

		Assert.isNotNull(g1);
		Assert.isNotNull(g2);

		Assert.areSame(g1, g2);
	}

	@Test public function graphics()
	{
		var shape = new Shape();

		var g1 = shape.graphics;
		var g2 = shape.graphics;

		Assert.isNotNull(g1);
		Assert.isNotNull(g2);

		Assert.areSame(g1, g2);
	}
}
