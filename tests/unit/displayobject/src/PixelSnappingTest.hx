import openfl.display.PixelSnapping;

class PixelSnappingTest
{
	public static function __init__()
	{
		Mocha.describe("PixelSnapping", function()
		{
			Mocha.it("test", function()
			{
				switch (PixelSnapping.NEVER)
				{
					case PixelSnapping.ALWAYS, PixelSnapping.AUTO, PixelSnapping.NEVER:
				}
			});
		});
	}
}
