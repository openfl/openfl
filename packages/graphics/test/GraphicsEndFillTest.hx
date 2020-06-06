import openfl.display.GraphicsEndFill;

class GraphicsEndFillTest
{
	public static function __init__()
	{
		Mocha.describe("GraphicsEndFill", function()
		{
			Mocha.it("new", function()
			{
				// TODO: Confirm functionality

				var endFill = new GraphicsEndFill();

				Assert.notEqual(endFill, null);
			});
		});
	}
}
