import openfl.ui.Keyboard;

class KeyboardTest
{
	public static function __init__()
	{
		Mocha.describe("Keyboard", function()
		{
			Mocha.it("test", function()
			{
				var exists = Keyboard.A;

				Assert.notEqual(exists, null);
			});
		});
	}
}
