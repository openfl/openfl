import openfl.display.StageQuality;

class StageQualityTest
{
	public static function __init__()
	{
		Mocha.describe("StageQuality", function()
		{
			Mocha.it("test", function()
			{
				switch (StageQuality.MEDIUM)
				{
					case StageQuality.BEST, StageQuality.HIGH, StageQuality.LOW, StageQuality.MEDIUM:
				}
			});
		});
	}
}
