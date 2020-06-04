package;

import openfl.events.AsyncErrorEvent;
import Mocha.*;

class AsyncErrorEventTest
{
	static function __init__()
		describe("Haxe | AsyncErrorEvent", () ->
		{
			it("error", () ->
			{
				// TODO: Confirm functionality
				var asyncErrorEvent = new AsyncErrorEvent(AsyncErrorEvent.ASYNC_ERROR);
				var exists = asyncErrorEvent.error;
				Assert.equal(exists, null);
			});
			it("new", () ->
			{
				// TODO: Confirm functionality
				var asyncErrorEvent = new AsyncErrorEvent(AsyncErrorEvent.ASYNC_ERROR);
				Assert.notEqual(asyncErrorEvent, null);
			});
		});
}
