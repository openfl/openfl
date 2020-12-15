package;

import openfl.display.GraphicsSolidFill;
import utest.Assert;
import utest.Test;

class GraphicsSolidFillTest extends Test
{
	public function test_alpha()
	{
		// TODO: Confirm functionality

		var solidFill = new GraphicsSolidFill();
		var exists = solidFill.alpha;

		Assert.notNull(exists);
	}

	public function test_color()
	{
		// TODO: Confirm functionality

		var solidFill = new GraphicsSolidFill();
		var exists = solidFill.color;

		Assert.notNull(exists);
	}

	public function test_new_()
	{
		// TODO: Confirm functionality

		var solidFill = new GraphicsSolidFill();

		Assert.notNull(solidFill);
	}
}
