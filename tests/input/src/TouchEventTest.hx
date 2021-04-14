package;

import openfl.display.Sprite;
import openfl.events.TouchEvent;
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
}
