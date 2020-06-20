import openfl.display.StageScaleMode;

class StageScaleModeTest
{
	public static function __init__()
	{
		Mocha.describe("StageScaleMode", function()
		{
			Mocha.it("test", function()
			{
				switch (StageScaleMode.SHOW_ALL)
				{
					case StageScaleMode.EXACT_FIT, StageScaleMode.NO_BORDER, StageScaleMode.NO_SCALE, StageScaleMode.SHOW_ALL:
				}
			});
		});
	}
}
