package;

import openfl.display.GraphicsPath;
import openfl.Vector;
import utest.Assert;
import utest.Test;

class GraphicsPathTest extends Test
{
	public function test_commands()
	{
		// TODO: Confirm functionality

		var commands = new Vector<Int>();
		var graphicsPath = new GraphicsPath(commands);
		var exists = graphicsPath.commands;

		Assert.notNull(exists);
	}

	public function test_data()
	{
		// TODO: Confirm functionality

		var data = new Vector<Float>();
		var graphicsPath = new GraphicsPath(null, data);
		var exists = graphicsPath.data;

		Assert.notNull(exists);
	}

	public function test_winding()
	{
		// TODO: Confirm functionality

		var graphicsPath = new GraphicsPath();
		var exists = graphicsPath.winding;

		Assert.notNull(exists);
	}

	public function test_new_()
	{
		// TODO: Confirm functionality

		var graphicsPath = new GraphicsPath();

		Assert.notNull(graphicsPath);
	}

	public function test_curveTo()
	{
		// TODO: Confirm functionality

		var graphicsPath = new GraphicsPath();
		var exists = graphicsPath.curveTo;

		Assert.notNull(exists);
	}

	public function test_lineTo()
	{
		// TODO: Confirm functionality

		var graphicsPath = new GraphicsPath();
		var exists = graphicsPath.lineTo;

		Assert.notNull(exists);
	}

	public function test_moveTo()
	{
		// TODO: Confirm functionality

		var graphicsPath = new GraphicsPath();
		var exists = graphicsPath.moveTo;

		Assert.notNull(exists);
	}

	public function test_wideLineTo()
	{
		// TODO: Confirm functionality

		var graphicsPath = new GraphicsPath();
		var exists = graphicsPath.wideLineTo;

		Assert.notNull(exists);
	}

	public function test_wideMoveTo()
	{
		// TODO: Confirm functionality

		var graphicsPath = new GraphicsPath();
		var exists = graphicsPath.wideMoveTo;

		Assert.notNull(exists);
	}
}
