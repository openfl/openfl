import openfl.events.UncaughtErrorEvents;

class UncaughtErrorEventsTest
{
	public static function __init__()
	{
		Mocha.describe("UncaughtErrorEvents", function()
		{
			Mocha.it("new", function()
			{
				// TODO: Confirm functionality

				var uncaughtErrorEvents = new UncaughtErrorEvents();

				Assert.notEqual(uncaughtErrorEvents, null);
			});
		});
	}
}
