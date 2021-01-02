package;

import openfl.display.GraphicsPathCommand;
import utest.Assert;
import utest.Test;

class GraphicsPathCommandTest extends Test
{
	public function test_test()
	{
		switch (GraphicsPathCommand.NO_OP)
		{
			case GraphicsPathCommand.NO_OP, GraphicsPathCommand.MOVE_TO, GraphicsPathCommand.LINE_TO, GraphicsPathCommand.CURVE_TO,
				GraphicsPathCommand.WIDE_MOVE_TO, GraphicsPathCommand.WIDE_LINE_TO /*, GraphicsPathCommand.CUBIC_CURVE_TO*/:
				Assert.isTrue(true);
			default:
		}
	}
}
