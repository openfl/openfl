import openfl.ui.Mouse;

class MouseTest
{
	public static function __init__()
	{
		Mocha.describe("Mouse", function()
		{
			Mocha.it("hide", function()
			{
				// TODO: Confirm functionality

				var exists = Mouse.hide;

				Assert.notEqual(exists, null);
			});

			Mocha.it("show", function()
			{
				// TODO: Confirm functionality

				var exists = Mouse.show;

				Assert.notEqual(exists, null);
			});
		});
	}
}
