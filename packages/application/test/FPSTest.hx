import openfl.display.FPS;

class FPSTest
{
	public static function __init__()
	{
		Mocha.describe("FPS", function()
		{
			Mocha.it("new", function()
			{
				// TODO: Confirm functionality

				var fps = new FPS();

				Assert.notEqual(fps, null);
			});
		});
	}
}
