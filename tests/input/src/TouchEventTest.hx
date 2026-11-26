package;

#if (lime && !flash)
import lime.ui.Touch;
#end
import openfl.display.Sprite;
import openfl.events.TouchEvent;
import openfl.Lib;
import utest.Assert;
import utest.Test;

class TouchEventTest extends Test
{
	public function test_altKey()
	{
		// TODO: Confirm functionality

		var touchEvent = new TouchEvent(TouchEvent.TOUCH_BEGIN);
		var exists = touchEvent.altKey;

		Assert.notNull(exists);
	}

	public function test_ctrlKey()
	{
		// TODO: Confirm functionality

		var touchEvent = new TouchEvent(TouchEvent.TOUCH_BEGIN);
		var exists = touchEvent.ctrlKey;

		Assert.notNull(exists);
	}

	public function test_isPrimaryTouchPoint()
	{
		// TODO: Confirm functionality

		var touchEvent = new TouchEvent(TouchEvent.TOUCH_BEGIN);
		var exists = touchEvent.isPrimaryTouchPoint;

		Assert.notNull(exists);
	}

	public function test_localX()
	{
		// TODO: Confirm functionality

		var touchEvent = new TouchEvent(TouchEvent.TOUCH_BEGIN);
		var exists = touchEvent.localX;

		Assert.notNull(exists);
	}

	public function test_localY()
	{
		// TODO: Confirm functionality

		var touchEvent = new TouchEvent(TouchEvent.TOUCH_BEGIN);
		var exists = touchEvent.localY;

		Assert.notNull(exists);
	}

	public function test_pressure()
	{
		// TODO: Confirm functionality

		var touchEvent = new TouchEvent(TouchEvent.TOUCH_BEGIN);
		var exists = touchEvent.pressure;

		Assert.notNull(exists);
	}

	public function test_relatedObject()
	{
		// TODO: Confirm functionality

		var touchEvent = new TouchEvent(TouchEvent.TOUCH_BEGIN);
		touchEvent.relatedObject = new Sprite();
		var exists = touchEvent.relatedObject;

		Assert.notNull(exists);
	}

	public function test_shiftKey()
	{
		// TODO: Confirm functionality

		var touchEvent = new TouchEvent(TouchEvent.TOUCH_BEGIN);
		var exists = touchEvent.shiftKey;

		Assert.notNull(exists);
	}

	public function test_sizeX()
	{
		// TODO: Confirm functionality

		var touchEvent = new TouchEvent(TouchEvent.TOUCH_BEGIN);
		var exists = touchEvent.sizeX;

		Assert.notNull(exists);
	}

	public function test_sizeY()
	{
		// TODO: Confirm functionality

		var touchEvent = new TouchEvent(TouchEvent.TOUCH_BEGIN);
		var exists = touchEvent.sizeY;

		Assert.notNull(exists);
	}

	public function test_stageX()
	{
		// TODO: Confirm functionality

		var touchEvent = new TouchEvent(TouchEvent.TOUCH_BEGIN);
		var exists = touchEvent.stageX;

		Assert.isTrue(Math.isNaN(exists));
	}

	public function test_stageY()
	{
		// TODO: Confirm functionality

		var touchEvent = new TouchEvent(TouchEvent.TOUCH_BEGIN);
		var exists = touchEvent.stageY;

		Assert.isTrue(Math.isNaN(exists));
	}

	public function test_touchPointID()
	{
		// TODO: Confirm functionality

		var touchEvent = new TouchEvent(TouchEvent.TOUCH_BEGIN);
		var exists = touchEvent.touchPointID;

		Assert.notNull(exists);
	}

	public function test_new_()
	{
		// TODO: Confirm functionality

		var touchEvent = new TouchEvent(TouchEvent.TOUCH_BEGIN);
		Assert.notNull(touchEvent);
	}

	public function test_updateAfterEvent()
	{
		// TODO: Confirm functionality

		var touchEvent = new TouchEvent(TouchEvent.TOUCH_BEGIN);
		var exists = touchEvent.updateAfterEvent;

		Assert.notNull(exists);
	}

	#if (!lime || flash)
	@Ignored
	#end
	public function test_timestamp()
	{
		#if (lime && !flash)
		if (Lib.current == null || Lib.current.stage == null)
		{
			Assert.pass("Skipping timestamp test without a stage");
			return;
		}

		var stage = Lib.current.stage;
		var touch = new Touch(0.5, 0.5, 4242, 0.0, 0.0, 1.0, 0);
		var timestamps:Array<Float> = [];
		var listener = function(event:TouchEvent):Void
		{
			timestamps.push(event.timestamp);
		};
		stage.addEventListener(TouchEvent.TOUCH_BEGIN, listener);
		stage.addEventListener(TouchEvent.TOUCH_END, listener);

		#if (lime >= "8.4.0")
		// the time the platform took the input, which Lime gives with each event
		Touch.onStart.__dispatchWithTimestamp(1234, touch);
		Touch.onEnd.__dispatchWithTimestamp(1300, touch);

		Assert.equals(1234, timestamps[0]);
		Assert.equals(1300, timestamps[1]);
		#else
		// older versions of Lime give no time, so it is the time of the dispatch
		var before = Lib.getTimer();
		Touch.onStart.dispatch(touch);
		Touch.onEnd.dispatch(touch);

		Assert.equals(2, timestamps.length);
		Assert.isTrue(timestamps[0] >= before && timestamps[1] >= timestamps[0]);
		#end

		stage.removeEventListener(TouchEvent.TOUCH_BEGIN, listener);
		stage.removeEventListener(TouchEvent.TOUCH_END, listener);
		#end
	}
}
