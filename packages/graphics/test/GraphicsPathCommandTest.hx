import openfl.display.GraphicsPathCommand;

class GraphicsPathCommandTest
{
	public static function __init__()
	{
		Mocha.describe("GraphicsPathCommand", function()
		{
			Mocha.it("test", function()
			{
				switch (GraphicsPathCommand.NO_OP)
				{
					case GraphicsPathCommand.NO_OP, GraphicsPathCommand.MOVE_TO, GraphicsPathCommand.LINE_TO, GraphicsPathCommand.CURVE_TO,
						GraphicsPathCommand.WIDE_MOVE_TO, GraphicsPathCommand.WIDE_LINE_TO /*, GraphicsPathCommand.CUBIC_CURVE_TO*/:
					default:
				}
			});
		});
	}
}
