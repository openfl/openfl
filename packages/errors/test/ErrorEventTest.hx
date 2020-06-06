package;

import openfl.events.ErrorEvent;

class ErrorEventTest
{
	public static function __init__()
	{
		Mocha.describe("ErrorEvent", function()
		{
			Mocha.it("errorID", function()
			{
				// TODO: Confirm functionality

				var errorEvent = new ErrorEvent(ErrorEvent.ERROR);
				var exists = errorEvent.errorID;

				Assert.notEqual(exists, null);
			});

			Mocha.it("new", function()
			{
				// TODO: Confirm functionality

				var errorEvent = new ErrorEvent(ErrorEvent.ERROR);
				Assert.notEqual(errorEvent, null);
			});
		});
	}
}
