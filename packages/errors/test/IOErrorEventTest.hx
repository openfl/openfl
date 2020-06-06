package;

import openfl.events.IOErrorEvent;

class IOErrorEventTest
{
	public static function __init__()
	{
		Mocha.describe("IOErrorEvent", function()
		{
			Mocha.it("new", function()
			{
				// TODO: Confirm functionality

				var ioErrorEvent = new IOErrorEvent(IOErrorEvent.IO_ERROR);
				Assert.notEqual(ioErrorEvent, null);
			});
		});
	}
}
