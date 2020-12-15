package;

import openfl.display.GraphicsSolidFill;
import openfl.display.GraphicsStroke;
import utest.Assert;
import utest.Test;

class GraphicsStrokeTest extends Test
{
	public function test_caps()
	{
		// TODO: Confirm functionality

		var stroke = new GraphicsStroke();
		var exists = stroke.caps;

		Assert.notNull(exists);
	}

	public function test_fill()
	{
		// TODO: Confirm functionality

		var stroke = new GraphicsStroke();
		stroke.fill = new GraphicsSolidFill();
		var exists = stroke.fill;

		Assert.notNull(exists);
	}

	public function test_joints()
	{
		// TODO: Confirm functionality

		var stroke = new GraphicsStroke();
		var exists = stroke.joints;

		Assert.notNull(exists);
	}

	public function test_miterLimit()
	{
		// TODO: Confirm functionality

		var stroke = new GraphicsStroke();
		var exists = stroke.miterLimit;

		Assert.notNull(exists);
	}

	public function test_pixelHinting()
	{
		// TODO: Confirm functionality

		var stroke = new GraphicsStroke();
		var exists = stroke.pixelHinting;

		Assert.notNull(exists);
	}

	public function test_scaleMode()
	{
		// TODO: Confirm functionality

		var stroke = new GraphicsStroke();
		var exists = stroke.scaleMode;

		Assert.notNull(exists);
	}

	public function test_thickness()
	{
		// TODO: Confirm functionality

		var stroke = new GraphicsStroke();
		var exists = stroke.thickness;

		Assert.notNull(exists);
	}

	public function test_new_()
	{
		// TODO: Confirm functionality

		var stroke = new GraphicsStroke();

		Assert.notNull(stroke);
	}
}
