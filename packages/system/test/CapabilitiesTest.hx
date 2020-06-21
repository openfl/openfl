import openfl.display.Stage;
import openfl.system.Capabilities;

class CapabilitiesTest
{
	public static function __init__()
	{
		Mocha.before(function()
		{
			var stage = new Stage(550, 400);
		});

		Mocha.describe("Capabilities", function()
		{
			Mocha.it("language", function()
			{
				// TODO: Confirm functionality

				var exists = Capabilities.language;

				Assert.notEqual(exists, null);
			});

			Mocha.it("screenDPI", function()
			{
				// TODO: Confirm functionality

				var exists = Capabilities.screenDPI;

				Assert.notEqual(exists, null);
			});

			Mocha.it("screenResolutionX", function()
			{
				// TODO: Confirm functionality

				var exists = Capabilities.screenResolutionX;

				Assert.notEqual(exists, null);
			});

			Mocha.it("screenResolutionY", function()
			{
				// TODO: Confirm functionality

				var exists = Capabilities.screenResolutionY;

				Assert.notEqual(exists, null);
			});
		});
	}
}
