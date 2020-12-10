import openfl.ui.Multitouch;

class MultitouchTest
{
	public static function __init__()
	{
		Mocha.describe("Multitouch", function()
		{
			Mocha.it("inputMode", function()
			{
				// TODO: Confirm functionality

				var exists = Multitouch.inputMode;

				Assert.notEqual(exists, null);
			});

			Mocha.it("maxTouchPoints", function()
			{
				// TODO: Confirm functionality

				var exists = Multitouch.inputMode;

				Assert.notEqual(exists, null);
			});

			Mocha.it("supportedGestures", function()
			{
				// TODO: Confirm functionality

				var exists = Multitouch.supportedGestures;

				// Is null if not supported
				// Assert.notEqual (exists, null);
			});

			Mocha.it("supportsGestureEvents", function()
			{
				// TODO: Confirm functionality

				var exists = Multitouch.supportsGestureEvents;

				Assert.notEqual(exists, null);
			});

			Mocha.it("supportsTouchEvents", function()
			{
				// TODO: Confirm functionality

				var exists = Multitouch.supportsTouchEvents;

				Assert.notEqual(exists, null);
			});
		});
	}
}
