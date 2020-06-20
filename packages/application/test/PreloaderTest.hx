import openfl.display.Preloader;

class PreloaderTest
{
	public static function __init__()
	{
		Mocha.describe("Preloader", function()
		{
			Mocha.it("new", function()
			{
				// TODO: Confirm functionality

				var preloader = new Preloader();
				var exists = preloader;

				Assert.notEqual(exists, null);
			});
		});
	}
}
