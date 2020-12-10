import openfl.ui.MultitouchInputMode;

class MultitouchInputModeTest
{
	public static function __init__()
	{
		Mocha.describe("MultitouchInputMode", function()
		{
			Mocha.it("test", function()
			{
				switch (MultitouchInputMode.GESTURE)
				{
					case MultitouchInputMode.GESTURE, MultitouchInputMode.NONE, MultitouchInputMode.TOUCH_POINT:
				}
			});
		});
	}
}
