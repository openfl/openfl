import openfl.display.StageDisplayState;

class StageDisplayStateTest
{
	public static function __init__()
	{
		Mocha.describe("StageDisplayState", function()
		{
			Mocha.it("test", function()
			{
				switch (StageDisplayState.NORMAL)
				{
					case StageDisplayState.FULL_SCREEN, StageDisplayState.FULL_SCREEN_INTERACTIVE, StageDisplayState.NORMAL:
				}
			});
		});
	}
}
