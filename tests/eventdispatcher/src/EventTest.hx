package;

import openfl.display.Sprite;
import openfl.events.Event;
import openfl.events.EventDispatcher;
import openfl.Lib;
import utest.Assert;
import utest.Test;

class EventTest extends Test
{
	public function test_bubbles()
	{
		// TODO: Confirm functionality

		var event = new Event(Event.ACTIVATE);
		var exists = event.bubbles;

		Assert.isFalse(exists);

		var dispatcher:EventDispatcher = null;
	}

	public function test_cancelable()
	{
		// TODO: Confirm functionality

		var event = new Event(Event.ACTIVATE);
		var exists = event.cancelable;

		Assert.isFalse(exists);
	}

	public function test_currentTarget()
	{
		// TODO: Confirm functionality

		var event = new Event(Event.ACTIVATE);
		var exists = event.currentTarget;

		Assert.isNull(exists);
	}

	public function test_eventPhase()
	{
		// TODO: Confirm functionality

		var event = new Event(Event.ACTIVATE);
		var exists = event.eventPhase;

		Assert.notNull(exists);
	}

	public function test_target()
	{
		// TODO: Confirm functionality

		var event = new Event(Event.ACTIVATE);
		var exists = event.target;

		Assert.isNull(exists);
	}

	public function test_type()
	{
		// TODO: Confirm functionality

		var event = new Event(Event.ACTIVATE);
		var exists = event.type;

		Assert.notNull(exists);
	}

	#if !integration
	@Ignored
	#end
	public function test_new_()
	{
		// TODO: Isolate so integration is not needed

		// ADDED

		var sprite = new Sprite();
		var sprite2 = new Sprite();

		var called = false;
		var called2 = false;

		var listener = function(e:Event)
		{
			called = true;

			Assert.equals(cast e.target, sprite);
			Assert.equals(cast e.currentTarget, sprite);
		}

		var listener2 = function(e:Event)
		{
			called2 = true;

			Assert.equals(cast e.target, sprite);
			Assert.equals(cast e.currentTarget, sprite2);
		}

		sprite.addEventListener(Event.ADDED, listener);
		sprite2.addEventListener(Event.ADDED, listener2);
		sprite2.addChild(sprite);

		Assert.isTrue(called);
		Assert.isTrue(called2);

		sprite.removeEventListener(Event.ADDED, listener);
		sprite2.removeEventListener(Event.ADDED, listener2);

		// ADDED_TO_STAGE

		called = false;
		called2 = false;

		var listener = function(e:Event)
		{
			called = true;

			Assert.equals(cast e.target, sprite);
			Assert.equals(cast e.currentTarget, sprite);
		}

		var listener2 = function(e:Event)
		{
			called2 = true;

			Assert.equals(cast e.target, sprite2);
			Assert.equals(cast e.currentTarget, sprite2);
		}

		sprite.addEventListener(Event.ADDED_TO_STAGE, listener);
		sprite2.addEventListener(Event.ADDED_TO_STAGE, listener2);
		Lib.current.stage.addChild(sprite2);

		Assert.isTrue(called);
		Assert.isTrue(called2);
	}

	public function test_clone()
	{
		// TODO: Confirm functionality

		var event = new Event(Event.ACTIVATE);
		var exists = event.clone;

		Assert.notNull(exists);
	}

	public function test_isDefaultPrevented()
	{
		// TODO: Confirm functionality

		var event = new Event(Event.ACTIVATE);
		var exists = event.isDefaultPrevented;

		Assert.notNull(exists);
	}

	public function test_stopImmediatePropagation()
	{
		// TODO: Confirm functionality

		var event = new Event(Event.ACTIVATE);
		var exists = event.stopImmediatePropagation;

		Assert.notNull(exists);
	}

	public function test_stopPropagation()
	{
		// TODO: Confirm functionality

		var event = new Event(Event.ACTIVATE);
		var exists = event.stopPropagation;

		Assert.notNull(exists);
	}
	/*public function toString () {



	}*/
}
