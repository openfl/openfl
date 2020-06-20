import openfl.events.Event;
import openfl.events.EventDispatcher;

class EventTest
{
	public static function __init__()
	{
		Mocha.describe("Event", function()
		{
			Mocha.it("bubbles", function()
			{
				// TODO: Confirm functionality

				var event = new Event(Event.ACTIVATE);
				var exists = event.bubbles;

				Assert.assert(!exists);
			});

			Mocha.it("cancelable", function()
			{
				// TODO: Confirm functionality

				var event = new Event(Event.ACTIVATE);
				var exists = event.cancelable;

				Assert.assert(!exists);
			});

			Mocha.it("currentTarget", function()
			{
				// TODO: Confirm functionality

				var event = new Event(Event.ACTIVATE);
				var exists = event.currentTarget;

				Assert.equal(exists, null);
			});

			Mocha.it("eventPhase", function()
			{
				// TODO: Confirm functionality

				var event = new Event(Event.ACTIVATE);
				var exists = event.eventPhase;

				Assert.notEqual(exists, null);
			});

			Mocha.it("target", function()
			{
				// TODO: Confirm functionality

				var event = new Event(Event.ACTIVATE);
				var exists = event.target;

				Assert.equal(exists, null);
			});

			Mocha.it("type", function()
			{
				// TODO: Confirm functionality

				var event = new Event(Event.ACTIVATE);
				var exists = event.type;

				Assert.notEqual(exists, null);
			});

			Mocha.it("new", function() {});

			Mocha.it("clone", function()
			{
				// TODO: Confirm functionality

				var event = new Event(Event.ACTIVATE);
				var exists = event.clone;

				Assert.notEqual(exists, null);
			});

			Mocha.it("isDefaultPrevented", function()
			{
				// TODO: Confirm functionality

				var event = new Event(Event.ACTIVATE);
				var exists = event.isDefaultPrevented;

				Assert.notEqual(exists, null);
			});

			Mocha.it("stopImmediatePropagation", function()
			{
				// TODO: Confirm functionality

				var event = new Event(Event.ACTIVATE);
				var exists = event.stopImmediatePropagation;

				Assert.notEqual(exists, null);
			});

			Mocha.it("stopPropagation", function()
			{
				// TODO: Confirm functionality

				var event = new Event(Event.ACTIVATE);
				var exists = event.stopPropagation;

				Assert.notEqual(exists, null);
			});

			/*public function toString", function () {



			}*/
		});
	}
}
