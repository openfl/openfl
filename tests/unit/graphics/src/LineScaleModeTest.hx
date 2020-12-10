import openfl.display.LineScaleMode;

class LineScaleModeTest
{
	public static function __init__()
	{
		Mocha.describe("LineScaleMode", function()
		{
			Mocha.it("test", function()
			{
				switch (LineScaleMode.VERTICAL)
				{
					case LineScaleMode.HORIZONTAL, LineScaleMode.NONE, LineScaleMode.NORMAL, LineScaleMode.VERTICAL:
				}
			});
		});
	}
}
