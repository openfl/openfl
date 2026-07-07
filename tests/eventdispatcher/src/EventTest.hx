package;

import openfl.events.EventPhase;
import openfl.display.Sprite;
import openfl.events.Event;
import openfl.events.EventDispatcher;
import openfl.Lib;
import utest.Assert;
import utest.Test;

@:access(openfl.events.Event)
class EventTest extends Test
{
	public function test_bubbles()
	{
		var event = new Event(Event.ACTIVATE);
		Assert.isFalse(event.bubbles);

		var event = new Event(Event.ACTIVATE, false);
		Assert.isFalse(event.bubbles);

		var event = new Event(Event.ACTIVATE, true);
		Assert.isTrue(event.bubbles);
	}

	public function test_cancelable()
	{
		var event = new Event(Event.ACTIVATE);
		Assert.isFalse(event.cancelable);

		var event = new Event(Event.ACTIVATE, false, false);
		Assert.isFalse(event.cancelable);

		var event = new Event(Event.ACTIVATE, false, true);
		Assert.isTrue(event.cancelable);
	}

	public function test_currentTarget()
	{
		var event = new Event(Event.ACTIVATE);
		Assert.isNull(event.currentTarget);

		var dispatcher = new EventDispatcher();
		dispatcher.dispatchEvent(event);

		#if flash
		// TODO: currentTarget is cleared after dispatching
		Assert.isNull(event.currentTarget);
		#end
	}

	public function test_eventPhase()
	{
		var event = new Event(Event.ACTIVATE);
		Assert.equals(EventPhase.AT_TARGET, event.eventPhase);
	}

	public function test_target()
	{
		var event = new Event(Event.ACTIVATE);
		Assert.isNull(event.target);

		var dispatcher = new EventDispatcher();
		dispatcher.dispatchEvent(event);

		#if flash
		// TODO: target is cleared after dispatching
		Assert.isNull(event.target);
		#end
	}

	public function test_type()
	{
		var event = new Event(Event.ACTIVATE);
		Assert.equals(Event.ACTIVATE, event.type);
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
		var event = new Event(Event.ACTIVATE, false, false);
		var clonedEvent = event.clone();

		Assert.equals(Event.ACTIVATE, clonedEvent.type);
		Assert.equals(false, clonedEvent.bubbles);
		Assert.equals(false, clonedEvent.cancelable);

		var event = new Event(Event.CLEAR, false, false);
		var clonedEvent = event.clone();

		Assert.equals(Event.CLEAR, clonedEvent.type);
		Assert.equals(false, clonedEvent.bubbles);
		Assert.equals(false, clonedEvent.cancelable);

		var event = new Event(Event.ACTIVATE, true, false);
		var clonedEvent = event.clone();

		Assert.equals(Event.ACTIVATE, clonedEvent.type);
		Assert.equals(true, clonedEvent.bubbles);
		Assert.equals(false, clonedEvent.cancelable);

		var event = new Event(Event.ACTIVATE, true, false);
		var clonedEvent = event.clone();

		Assert.equals(Event.ACTIVATE, clonedEvent.type);
		Assert.equals(true, clonedEvent.bubbles);
		Assert.equals(false, clonedEvent.cancelable);

		var event = new Event(Event.ACTIVATE, false, false);
		event.preventDefault();
		var clonedEvent = event.clone();

		Assert.equals(Event.ACTIVATE, clonedEvent.type);
		Assert.equals(false, clonedEvent.bubbles);
		Assert.equals(false, clonedEvent.cancelable);
		// if the original is default prevented, the clone is not
		Assert.equals(false, clonedEvent.isDefaultPrevented());

		#if !flash
		var event = new Event(Event.ACTIVATE, false, false);
		event.stopPropagation();
		var clonedEvent = event.clone();

		Assert.equals(Event.ACTIVATE, clonedEvent.type);
		Assert.equals(false, clonedEvent.bubbles);
		Assert.equals(false, clonedEvent.cancelable);
		// if the original is stopped, the clone is not
		Assert.equals(false, clonedEvent.__isCanceled);
		Assert.equals(false, clonedEvent.__isCanceledNow);

		var event = new Event(Event.ACTIVATE, false, false);
		event.stopImmediatePropagation();
		var clonedEvent = event.clone();

		Assert.equals(Event.ACTIVATE, clonedEvent.type);
		Assert.equals(false, clonedEvent.bubbles);
		Assert.equals(false, clonedEvent.cancelable);
		// if the original is stopped, the clone is not
		Assert.equals(false, clonedEvent.__isCanceled);
		Assert.equals(false, clonedEvent.__isCanceledNow);
		#end
	}

	public function test_isDefaultPrevented()
	{
		var nonCancelableEvent = new Event(Event.ACTIVATE, false, false);
		Assert.isFalse(nonCancelableEvent.isDefaultPrevented());
		nonCancelableEvent.preventDefault();
		Assert.isFalse(nonCancelableEvent.isDefaultPrevented());

		var cancelableEvent = new Event(Event.ACTIVATE, false, true);
		Assert.isFalse(cancelableEvent.isDefaultPrevented());
		cancelableEvent.preventDefault();
		Assert.isTrue(cancelableEvent.isDefaultPrevented());
	}

	#if !flash
	// there's no public API to check for stopped propagation to check on flash
	public function test_stopImmediatePropagation()
	{
		var event = new Event(Event.ACTIVATE);

		Assert.isFalse(event.__isCanceled);
		Assert.isFalse(event.__isCanceledNow);

		event.stopImmediatePropagation();

		Assert.isTrue(event.__isCanceled);
		Assert.isTrue(event.__isCanceledNow);
	}
	#end

	#if !flash
	// there's no public API to check for stopped propagation to check on flash
	public function test_stopPropagation()
	{
		var event = new Event(Event.ACTIVATE);

		Assert.isFalse(event.__isCanceled);
		Assert.isFalse(event.__isCanceledNow);

		event.stopPropagation();

		Assert.isTrue(event.__isCanceled);
		Assert.isFalse(event.__isCanceledNow);
	}
	#end
	/*public function toString () {



	}*/
}
